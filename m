Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab1F1KuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:50:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36930 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab1F1Ksx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:48:53 -0400
Subject: Re: [PATCH] perf: removed a non-existent event
 "L1-icache-prefetches" for AMD processors
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Zhengyu He <zhengyuh@google.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>,
        Andre Przywara <andre.przywara@amd.com>
In-Reply-To: <1309211910-2803-1-git-send-email-zhengyuh@google.com>
References: <1309211910-2803-1-git-send-email-zhengyuh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 28 Jun 2011 12:47:43 +0200
Message-ID: <1309258063.6701.198.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 14:58 -0700, Zhengyu He wrote:
> According to AMD's "BIOS and Kernel Developer's Guide for AMD NPT Family
> 0Fh Processors"
> (http://support.amd.com/us/Processor_TechDocs/32559.pdf), 0x4B is for
> prefetch instructions dispatched, and 0x14B is for the load prefetch
> instructions including Pretech and PrefetchT0/T1/T2. No event for the
> instructions preteched into L1I cache is found.
> 
> Signed-off-by: Zhengyu He <zhengyuh@google.com>

Hmm, indeed, its prefetch instructions issues, but not instruction
prefetches, Robert, Andre agreed?

> ---
>  arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index fe29c1d..3b7f21d 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -29,7 +29,7 @@ static __initconst const u64 amd_hw_cache_event_ids
>  		[ C(RESULT_MISS)   ] = -1,
>  	},
>  	[ C(OP_PREFETCH) ] = {
> -		[ C(RESULT_ACCESS) ] = 0x014B, /* Prefetch Instructions :Load */
> +		[ C(RESULT_ACCESS) ] = 0,
>  		[ C(RESULT_MISS)   ] = 0,
>  	},
>   },

