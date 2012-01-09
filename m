Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2AILGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:06:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:39803 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2AILGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:06:08 -0500
Message-ID: <1326107156.2442.59.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Date: Mon, 09 Jan 2012 12:05:56 +0100
In-Reply-To: <20120110001445.GA20542@linux-youquan.bj.intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins>
	 <20120110001445.GA20542@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 19:14 -0500, Youquan Song wrote:
> Fine, I will base your suggestion to develop another patch soon.
> 

> 
> @@ -3923,6 +3923,10 @@ static inline void update_sg_lb_stats(struct
> sched_domain *sd,
>                                                 SCHED_POWER_SCALE);
>         if (!sgs->group_capacity)
>                 sgs->group_capacity = fix_small_capacity(sd, group);
> +
> +       if (sched_smt_power_savings)
> +               sgs->group_capacity *= 2; 

Note, this has the hard-coded assumption you only have 2 threads per
core, which while true for intel, isn't true in general. I think you
meant to write *= group->group_weight or somesuch.

Also, you forgot to limit this to the SD_SHARE_CPUPOWER domain, you're
now doubling the capacity for all domains.

Furthermore, have a look at the SD_PREFER_SIBLING logic and make sure
you're not fighting that.
