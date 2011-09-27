Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1I0KLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:11:46 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:20828
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab1I0KLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:11:45 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Tue, 27 Sep 2011 18:21:36 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 0/3] genirq: handling GIC per-cpu interrupts
Message-ID: <20110927102135.GD17997@S2100-06.ap.freescale.net>
References: <1316793788-14500-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316793788-14500-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 05:03:05PM +0100, Marc Zyngier wrote:
> The current GIC per-cpu interrupts (aka PPIs) suffer from a number of
> problems:
> 
> - They use a completely separate scheme to handle the interrupts,
>   mostly because the PPI concept doesn't really match the kernel view
>   of an interrupt.
> - PPIs can only be used by the timer code, unless we add more low-level
>   assembly code.
> - The local timer code can only be used by devices generating PPIs,
>   and not SPIs.
> - At least one platform (msm) has started implementing its own
>   alternative scheme.
> - Some low-level code gets duplicated, as usual...
> 
> The proposed solution is to handle the PPIs using the same path as
> SPIs. A new core API is added to deal with per-cpu interrupts in a
> less awkward way. The local timer code is updated to reflect these
> changes.
> 
> The core API changes are based on an initial idea by Thomas Gleixner.
> 
> Tested on ARM Versatile Express (Cortex A15), ARM RealView PB11MP,
> OMAP4 (Panda) and Tegra (Harmony). Patch series against next-20110923.
> 
> From v2:
> - Fixed !GENERIC_HARDIRQS build
> - Fixed request_percpu_irq documentation
> 
> From v1:
> - General tidy-up after Thomas' review. I've kept the config option
>   for the time being until we can sort out the anonymous union
>   problem.
> 
> Marc Zyngier (3):
>   genirq: add support for per-cpu dev_id interrupts
>   ARM: gic: consolidate PPI handling
>   ARM: gic, local timers: use the request_percpu_irq() interface
> 
On imx6q:

Tested-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn

