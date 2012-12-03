Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab2LCR4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:56:50 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:38006 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2LCR4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:56:48 -0500
Date: Mon, 3 Dec 2012 18:01:25 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 3/5] device_cgroup: keep track of local group settings
Message-ID: <20121203180125.GA30637@mail.hallyn.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.482004744@napanee.usersys.redhat.com>
 <20121129192945.GD26104@mail.hallyn.com>
 <20121129195942.GW32112@redhat.com>
 <20121129202608.GA26716@mail.hallyn.com>
 <20121129223111.GZ32112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129223111.GZ32112@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> On Thu, Nov 29, 2012 at 08:26:08PM +0000, Serge E. Hallyn wrote:
> > Quoting Aristeu Rozanski (aris@redhat.com):
> > > I see your point. it's indeed a problem. in dev_exception_add(), it
> > > needs to check for permissions before actually adding to
> > > devcgroup->exceptions.
> 
> actually, checked again, it's done correctly. when adding an exception
> that will allow extra device access (DEVCG_ALLOW), it does check it
> before. It means that you can't add local exceptions unless at a certain
> point of the time it was allowed to do so.

Thanks.

...

> git://github.com/aristeu/linux-2.6.git
> 
> please use branch devcg_hiearchy_review

Thanks!

I have a few remaining concerns.

First, generally, I don't think 'allows' added to parent should be 
automatically propagated to descendents.

In devcgroup_update_access: (around line 625)
	there is a period of time where cgroup members have
	default allow without the parent's exceptions.

propagate_behavior (line 505):
	1. doesn't follow the same ordering as devcgroup_update_access(), in
	particular cleaning exceptions before setting behavior.
	2. When changing a parent from deny to allow, I don't think children
	should be updated.

propagate_exception:
	1. the WARN_ONCE doesn't seem helpful.
	2. Again, I don't think allows to a parent should be propagated, only
	denies.

-serge
