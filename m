Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965754Ab2JaV1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:27:32 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:65404 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899Ab2JaV1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:27:30 -0400
Date: Wed, 31 Oct 2012 14:27:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 4/8] cgroup: deactivate CSS's and mark cgroup dead before
 invoking ->pre_destroy()
Message-ID: <20121031212725.GA2945@htj.dyndns.org>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
 <1351712650-23709-5-git-send-email-tj@kernel.org>
 <20121031212359.GC5286@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031212359.GC5286@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Wed, Oct 31, 2012 at 10:23:59PM +0100, Michal Hocko wrote:
> > +	for_each_subsys(cgrp->root, ss)
> > +		if (ss->pre_destroy)
> > +			WARN_ON_ONCE(ss->pre_destroy(cgrp));
> 
> Do you think that BUG_ON would be too harsh?

Yeah, I do think so.  In general, I think the consensus now is to
prefer WARN_ON[_ONCE]() over BUG_ON() whenever possible.  It's not
like we can get more information from BUG_ON()s (more likely to get
less reporting actually by taking down the machine).  Limping machines
are better than dead ones and there just isn't much to gain here by
killing it.

Thanks.

-- 
tejun
