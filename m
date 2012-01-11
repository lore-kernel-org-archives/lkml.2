Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab2AKLN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:13:26 -0500
Received: from lunge.queued.net ([173.255.254.236]:57057 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808Ab2AKLNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:13:12 -0500
Date: Wed, 11 Jan 2012 02:15:11 -0800
From: Andres Salomon <dilinger@queued.net>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: [PATCH] cs5535-clockevt: allow the MFGPT IRQ to be shared
Message-ID: <20120111021511.44497bac@debxo>
In-Reply-To: <4EF35C66.6010402@LiPPERTEmbedded.de>
References: <4EE620A5.7080402@LiPPERTEmbedded.de>
	<20111212123131.502be350@queued.net>
	<4EE77416.8090907@LiPPERTEmbedded.de>
	<4EE8ECF3.6000900@LiPPERTEmbedded.de>
	<20111214104724.292b02d4@queued.net>
	<4EF35C66.6010402@LiPPERTEmbedded.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems fine to me

Acked-by: Andres Salomon <dilinger@queued.net>

On Thu, 22 Dec 2011 17:35:50 +0100
Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:

> cs5535-clockevt: allow the MFGPT IRQ to be shared
> 
> Shared timer IRQs are not a good solution, however the Geode platform
> has no APIC, IRQs are a scarce resource and there is no technical
> reason to forbid it rightaway.  Increased latencies and overhead due
> to sharing are still better than a driver refusing to load.
> 
> Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
> ---
> 
> Hi,
> 
> I tested this a bit longer, this time with MFGPT IRQ actually being
> triggered, with cs5535-clockevt driver loaded first or second when
> sharing the IRQ, with some CPU load or without.
> 
> I didn't encounter any negative effects of this change. I did have
> suspend problems with cs5535-clockevt, but that was in no way
> different from before I applied this patch, it's an unrelated BIOS
> issue.
> 
> Thomas Gleixner wrote:
> > No, you can share a timer irq. The other drivers don't have the
> > SHARED flag set because they are on exclusive irq lines, ...
> 
> Is this an ACK?
> 
> > shared irqs suck and you figure that out once you try to
> > use that shared timer irq on a preempt-rt enabled kernel.
> 
> Or a NACK?  :-|   (I did address this in the commit log.)
> 
> The kernel I tested with was 3.2-rc6, CONFIG_SMP=y and
> CONFIG_PREEMPT=y. As I said, I didn't notice anything bad happening.
> 
> Thanks and have a nice christmas holiday,
> Jens
> 
> --- linux-3.2-rc6/drivers/clocksource/cs5535-clockevt.c
> +++ allow_shared_mfgpt_irq/drivers/clocksource/cs5535-clockevt.c
> @@ -133,7 +133,7 @@ static irqreturn_t mfgpt_tick(int irq, v
>  
>  static struct irqaction mfgptirq  = {
>  	.handler = mfgpt_tick,
> -	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
> +	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER |
> IRQF_SHARED, .name = DRV_NAME,
>  };
>  
> _
> 

