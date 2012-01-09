Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2AIKar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:30:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:39430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2AIKap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:30:45 -0500
Message-ID: <1326105039.2442.54.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <peterz@infradead.org>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Paul Turner <pjt@google.com>
Date: Mon, 09 Jan 2012 11:30:39 +0100
In-Reply-To: <1326104915.2442.53.camel@twins>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins> <1326104915.2442.53.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 11:28 +0100, Peter Zijlstra wrote:
> +++ b/arch/x86/kernel/smpboot.c
> @@ -414,8 +414,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>          * For perf, we return last level cache shared map.
>          * And for power savings, we return cpu_core_map
>          */
> -       if ((sched_mc_power_savings || sched_smt_power_savings) &&
> -           !(cpu_has(c, X86_FEATURE_AMD_DCM)))
> +       if (!(cpu_has(c, X86_FEATURE_AMD_DCM)))
>                 return cpu_core_mask(cpu);
>         else
>                 return cpu_llc_shared_mask(cpu); 

That should of course become:

 return cpu_llc_shared_mask(cpu);


