Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2HTJlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:41:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59156 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2HTJlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:41:44 -0400
Date: Mon, 20 Aug 2012 11:41:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        andi@firstfloor.org, zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86: enable Intel Cedarview Atom suppport
Message-ID: <20120820094138.GA16230@one.firstfloor.org>
References: <20120820092421.GA11284@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820092421.GA11284@quad>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 7f2739e..0d3d63a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2008,6 +2008,7 @@ __init int intel_pmu_init(void)
>  		break;
>  
>  	case 28: /* Atom */
> +	case 54: /* Cedariew */

Ack. We currently miss some more 32nm Atoms too, will send patches soon.

>  		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
>  		       sizeof(hw_cache_event_ids));
>  
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index 520b426..da02e9c 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -686,7 +686,8 @@ void intel_pmu_lbr_init_atom(void)
>  	 * to have an operational LBR which can freeze
>  	 * on PMU interrupt
>  	 */
> -	if (boot_cpu_data.x86_mask < 10) {
> +	if (boot_cpu_data.x86_model == 28
> +	    && boot_cpu_data.x86_mask < 10) {

Is that correct?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
