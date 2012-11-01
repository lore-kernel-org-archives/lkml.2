Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762024Ab2KAPn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:43:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53796 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032Ab2KAPnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:43:25 -0400
Date: Thu, 1 Nov 2012 08:43:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in
 cgroup_create()
Message-ID: <20121101154320.GA8712@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-4-git-send-email-tj@kernel.org>
 <20121031155514.GD22809@dhcp22.suse.cz>
 <20121031170431.GF2945@htj.dyndns.org>
 <20121101091644.GA8533@dhcp22.suse.cz>
 <CAOS58YM+kRtspVUzmnSmOmrDoNS_kF6KA02zWGxqH5FUcRWo1Q@mail.gmail.com>
 <20121101150532.GA5065@dhcp22.suse.cz>
 <20121101151556.GB5065@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101151556.GB5065@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Thu, Nov 01, 2012 at 04:15:56PM +0100, Michal Hocko wrote:
> > 	if (!cgroup_lock_live_group(parent))
> > 		return -ENODEV;
> > 
> >         cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
> >         if (!cgrp)
> >                 return -ENOMEM;
> 
> this needs to drop the lock of course but it doesn't make it much more
> complicated...

Yeah, now look at the error exit path of the function.  You have to
reorder them too so that it matches the changed order above, which is
all fine and dandy, but one way is not necessarily better than the
other, so there's no good reason to incur that churn.

Thanks.

-- 
tejun
