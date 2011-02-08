Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab1BHEwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 23:52:46 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:46869 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1BHEwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 23:52:45 -0500
Message-ID: <4D50CC05.6070003@snapgear.com>
Date: Tue, 8 Feb 2011 14:52:21 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [patch 01/10] m68knommu: 5772: Replace private irq flow handler
References: <20110206233845.480884215@linutronix.de> <20110206233904.203393608@linutronix.de>
In-Reply-To: <20110206233904.203393608@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2011 04:52:40.0861 (UTC) FILETIME=[03FDFCD0:01CBC74C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

On 07/02/11 09:39, Thomas Gleixner wrote:
> That handler lacks the minimal checks for action being zero etc. Keep
> the weird flow - ack before handling - intact and call into
> handle_simple_irq which does the right thing.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> LKML-Reference: <20110202212552.413849952@linutronix.de>

Nitpick, the title should read "5272" not "5772".

Regards
Greg


> ---
>  arch/m68knommu/platform/5272/intc.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> Index: linux-next/arch/m68knommu/platform/5272/intc.c
> ===================================================================
> --- linux-next.orig/arch/m68knommu/platform/5272/intc.c
> +++ linux-next/arch/m68knommu/platform/5272/intc.c
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
