Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267Ab2FVQg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:36:59 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:13263
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab2FVQg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:36:58 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M6125B-01-2VE-02
X-M-MSG: 
Date: Fri, 22 Jun 2012 18:36:43 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, x86: Improve debug output in check_hw_exists()
Message-ID: <20120622163643.GK24632@erda.amd.com>
References: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
 <1340217996-2254-5-git-send-email-robert.richter@amd.com>
 <1340380427.18025.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340380427.18025.84.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.06.12 17:53:47, Peter Zijlstra wrote:
> My gcc wants me to add the below to avoid used uninitialized warns:
> 
> ---
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -211,8 +211,9 @@ static bool check_hw_exists(void)
>  	 * that don't trap on the MSR access and always return 0s.
>  	 */
>  	val = 0xabcdUL;
> -	ret = wrmsrl_safe(x86_pmu_event_addr(0), val);
> -	ret |= rdmsrl_safe(x86_pmu_event_addr(0), &val_new);
> +	reg = x86_pmu_event_addr(0);
> +	ret = wrmsrl_safe(reg, val);
> +	ret |= rdmsrl_safe(reg, &val_new);

Yes, this is correct. It fixes also correct reporting of reg if it
fails here.

I wonder why my gcc this didn't report, its 4.4.5.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

