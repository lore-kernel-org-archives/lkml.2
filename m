Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab2FKVUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:20:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59333 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751231Ab2FKVUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:20:19 -0400
Message-ID: <1339449617.27188.5.camel@joe2Laptop>
Subject: Re: [PATCH v3] watchdog: Quiet down the boot messages
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        nzimmer@sgi.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 11 Jun 2012 14:20:17 -0700
In-Reply-To: <20120611211239.GA12721@redhat.com>
References: <1339445050-29941-1-git-send-email-dzickus@redhat.com>
	 <20120611211239.GA12721@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 17:12 -0400, Dave Jones wrote:
[]
> Would anyone object to compressing these lines too ?
>  
>  >     ... version:                2
>  >     ... bit width:              40
>  >     ... generic registers:      2
>  >     ... value mask:             000000ffffffffff
>  >     ... max period:             000000007fffffff
>  >     ... fixed-purpose events:   3
>  >     ... event mask:             0000000700000003
[]
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
[]
> @@ -1389,13 +1389,13 @@ static int __init init_hw_perf_events(void)
>  	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
>  	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
>  
> -	pr_info("... version:                %d\n",     x86_pmu.version);
> -	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
> -	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
> -	pr_info("... value mask:             %016Lx\n", x86_pmu.cntval_mask);
> -	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
> -	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
> -	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
> +	pr_info("... version: %d ", x86_pmu.version);
> +	pr_info("bit width: %d ", x86_pmu.cntval_bits);
> +	pr_info("generic registers: %d\n", x86_pmu.num_counters);
> +	pr_info("... value mask: %016Lx ", x86_pmu.cntval_mask);
> +	pr_info("max period: %016Lx ", x86_pmu.max_period);
> +	pr_info("fixed-purpose events: %d ", x86_pmu.num_counters_fixed);
> +	pr_info("event mask: %016Lx\n", x86_pmu.intel_ctrl);

That wouldn't work.

Every pr_<level> other than pr_cont will always be start a new line.

You want pr_cont for each of these other than the ... ones.

It'd be better too just to use 2 pr_info lines like:

	pr_info("... version: %d bit width: %d generic registers: %d\n",
		x86_pmu.version, x86_pmu.cntval_bits, x86_pmu.num_counters);
	pr_info("... value mask: %016Lx max period: %016Lx fixed-purpose events: %d event mask: %016Lx\n",
		x86_pmu.cntval_mask, x86_pmu.max_period,
		x86_pmu.num_counters_fixed, x86_pmu.intel_ctrl);

