Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0H0Hxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:53:42 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:37052 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab0H0Hxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:53:40 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7SWHV-02-DG3-02
X-M-MSG: 
Date: Fri, 27 Aug 2010 09:51:32 +0200
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
Message-ID: <20100827075132.GD22783@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100826211424.GQ4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100826211424.GQ4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
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

Yes, not immediately ack'ing the status was suspect to me too. Though
it must then be the same counter that retriggers. Or, it is a cpu
bug. You could add a debug print of the status register for the case
the loop is reentered, would be interesting...

Thank for fixing this.

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

