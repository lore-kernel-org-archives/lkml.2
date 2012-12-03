Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2LCTHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:07:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab2LCTHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:07:06 -0500
Date: Mon, 3 Dec 2012 14:06:58 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH 3/5] device_cgroup: keep track of local group settings
Message-ID: <20121203190657.GD32112@redhat.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.482004744@napanee.usersys.redhat.com>
 <20121129192945.GD26104@mail.hallyn.com>
 <20121129195942.GW32112@redhat.com>
 <20121129202608.GA26716@mail.hallyn.com>
 <20121129223111.GZ32112@redhat.com>
 <20121203180125.GA30637@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203180125.GA30637@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 06:01:25PM +0000, Serge E. Hallyn wrote:
> First, generally, I don't think 'allows' added to parent should be 
> automatically propagated to descendents.

that's what I think too and what I tried to do

> In devcgroup_update_access: (around line 625)
> 	there is a period of time where cgroup members have
> 	default allow without the parent's exceptions.

true, will fix that one and look for more cases

> propagate_behavior (line 505):
> 	1. doesn't follow the same ordering as devcgroup_update_access(), in
> 	particular cleaning exceptions before setting behavior.

I see, will update that

> 	2. When changing a parent from deny to allow, I don't think children
> 	should be updated.

I disagree on this one. since there'll be local preferences, it'll try
to revalidate them everytime there's a change. so, for example, an
exception that might not be possible now, will be possible when its
parent changes in a way that allows that.

-- 
Aristeu

