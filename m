Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab2JaQla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:41:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41637 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab2JaQl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:41:28 -0400
Date: Wed, 31 Oct 2012 09:41:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Message-ID: <20121031164123.GD2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-2-git-send-email-tj@kernel.org>
 <20121031143751.GA22809@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031143751.GA22809@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Wed, Oct 31, 2012 at 03:37:51PM +0100, Michal Hocko wrote:
> > +	for_each_subsys(cgrp->root, ss)
> > +		if (ss->pre_destroy)
> > +			WARN_ON_ONCE(ss->pre_destroy(cgrp));
> 
> Hmm, I am not sure I like this WARN_ON_ONCE. First it can happen for
> more than one controller and second we can just clear CGRP_WAIT_ON_RMDIR
> and return with EBUSY. The only possible failure at the moment is when a
> new task or a child group appear.
> I know it is not a big deal because it will disappear later in the
> series but it would be more readable IMO.

The WARN_ON_ONCE() is just moved from the original
cgroup_call_pre_destroy().  We can add an error out there but that
makes future changes difficult.  It's a chicken and egg problem.  You
gotta break the loop somewhere.

Thanks.

-- 
tejun
