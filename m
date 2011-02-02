Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1BBW34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:29:56 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:40042 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1BBW3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:29:55 -0500
Message-ID: <4D49DA5B.10308@snapgear.com>
Date: Thu, 3 Feb 2011 08:27:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [patch 7/8] m68knommu: 5772: Replace private irq flow handler
References: <20110202212258.546660886@linutronix.de> <20110202212552.413849952@linutronix.de>
In-Reply-To: <20110202212552.413849952@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

On 03/02/11 07:41, Thomas Gleixner wrote:
> That handler lacks the minimal checks for action being zero etc. Keep
> the weird flow - ack before handling - intact and call into
> handle_simple_irq which does the right thing.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Ungerer <gerg@uclinux.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>

(I can't test this change for a week or two at least, I don't
have access to any 5272 based boards at the moment.)

Do you want me to push it through the m68knommu tree,
or are you going to do that yourself?

Regards
Greg


> ---
>  arch/m68knommu/platform/5272/intc.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> Index: linux-2.6-tip/arch/m68knommu/platform/5272/intc.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68knommu/platform/5272/intc.c
> +++ linux-2.6-tip/arch/m68knommu/platform/5272/intc.c
> @@ -137,11 +137,8 @@ static int intc_irq_set_type(unsigned in
>   */
>  static void intc_external_irq(unsigned int irq, struct irq_desc *desc)
>  {
> -	kstat_incr_irqs_this_cpu(irq, desc);
> -	desc->status |= IRQ_INPROGRESS;
>  	desc->chip->ack(irq);
> -	handle_IRQ_event(irq, desc->action);
> -	desc->status &= ~IRQ_INPROGRESS;
> +	handle_simple_irq(irq, desc);
>  }
>
>  static struct irq_chip intc_irq_chip = {

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
