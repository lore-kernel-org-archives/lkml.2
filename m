Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab0H0IMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:12:46 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:40236 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0H0IMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:12:44 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqzbb2cK1432N98dNzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L7SXDQ-01-8T9-02
X-M-MSG: 
Date: Fri, 27 Aug 2010 10:10:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100827081038.GF22783@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100826211424.GQ4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100826211424.GQ4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.10 17:14:24, Don Zickus wrote:
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 4539b4b..d16ebd8 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -738,6 +738,7 @@ again:
>  
>  	inc_irq_stat(apic_perf_irqs);
>  	ack = status;
> +	intel_pmu_ack_status(ack);

I would slightly change the patch:

There is no need for the ack variable anymore, you could directly work
with the status.

I would call intel_pmu_ack_status() as close as possible after the
intel_pmu_get_status(), which is after 'again:'.

-Robert

>  
>  	intel_pmu_lbr_read();
>  
> @@ -766,8 +767,6 @@ again:
>  			x86_pmu_stop(event);
>  	}
>  
> -	intel_pmu_ack_status(ack);
> -
>  	/*
>  	 * Repeat if there is more work to be done:
>  	 */
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

