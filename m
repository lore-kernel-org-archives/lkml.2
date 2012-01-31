Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2AaUCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:02:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:57191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2AaUCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:02:36 -0500
Message-ID: <1328040137.2446.242.camel@twins>
Subject: RE: [PATCH] scheduler: domain: init next_balance in
 nohz_idle_balancer with jiffies
From: Peter Zijlstra <peterz@infradead.org>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Kamalesh Babulal'" <kamalesh@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 21:02:17 +0100
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE466523791832BE9@HQMAIL04.nvidia.com>
References: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
	 <1328024684.2446.234.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE466523791832BE9@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 11:23 -0800, Diwakar Tundlam wrote:
> Here's the patch for kernel 3.3-rc1:
> 
> ** kernel/sched/fair.c	2012-01-31 11:19:52.032421593 -0800
> ***************
> *** 5585,5597 ****
>   
>   __init void init_sched_fair_class(void)
>   {
>   #ifdef CONFIG_SMP
>   	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
>   
>   #ifdef CONFIG_NO_HZ
>   	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
> + 	nohz.next_balance = jiffies;
>   #endif
>   #endif /* SMP */
>   
>   }

This is not something I can apply, please see
Documentation/SubmittingPatches.
