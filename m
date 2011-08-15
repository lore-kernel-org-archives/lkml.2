Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1HOLPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:15:33 -0400
Received: from www.xora.org.uk ([80.68.91.202]:42408 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1HOLPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:15:32 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Aug 2011 07:15:32 EDT
Message-ID: <4E48FDC9.5090309@xora.org.uk>
Date: Mon, 15 Aug 2011 12:06:49 +0100
From: Graeme Gregory <dp@xora.org.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mfd: tps65910: fix initialisation of interrupts
References: <1313404923-2502-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1313404923-2502-1-git-send-email-jhovold@gmail.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/2011 11:42, Johan Hovold wrote:
> Fix regression introduced by commit
> a2974732ca7614aaf0baf9d6dd3ad893d50ce1c5 (TPS65911: Add new irq
> definitions) which caused irq_num to be incorrectly set for tps65910.
>
> Cc: stable@kernel.org
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  drivers/mfd/tps65910-irq.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
> index 2bfad5c..a56be93 100644
> --- a/drivers/mfd/tps65910-irq.c
> +++ b/drivers/mfd/tps65910-irq.c
> @@ -178,8 +178,10 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
>  	switch (tps65910_chip_id(tps65910)) {
>  	case TPS65910:
>  		tps65910->irq_num = TPS65910_NUM_IRQ;
> +		break;
>  	case TPS65911:
>  		tps65910->irq_num = TPS65911_NUM_IRQ;
> +		break;
>  	}
>  
>  	/* Register with genirq */
Whole series

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

