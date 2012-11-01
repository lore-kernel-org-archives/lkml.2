Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2KAI6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 04:58:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab2KAI6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 04:58:35 -0400
Date: Thu, 1 Nov 2012 09:58:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 4/8] cgroup: deactivate CSS's and mark cgroup dead before
 invoking ->pre_destroy()
Message-ID: <20121101085832.GB8525@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
 <1351712650-23709-5-git-send-email-tj@kernel.org>
 <20121031212359.GC5286@dhcp22.suse.cz>
 <20121031212725.GA2945@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031212725.GA2945@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-10-12 14:27:25, Tejun Heo wrote:
> Hey, Michal.
> 
> On Wed, Oct 31, 2012 at 10:23:59PM +0100, Michal Hocko wrote:
> > > +	for_each_subsys(cgrp->root, ss)
> > > +		if (ss->pre_destroy)
> > > +			WARN_ON_ONCE(ss->pre_destroy(cgrp));
> > 
> > Do you think that BUG_ON would be too harsh?
> 
> Yeah, I do think so.  In general, I think the consensus now is to
> prefer WARN_ON[_ONCE]() over BUG_ON() whenever possible.  It's not
> like we can get more information from BUG_ON()s (more likely to get
> less reporting actually by taking down the machine).  Limping machines
> are better than dead ones and there just isn't much to gain here by
> killing it.

Fair enough

-- 
Michal Hocko
SUSE Labs
