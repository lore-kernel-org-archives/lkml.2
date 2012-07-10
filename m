Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2GJGSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:18:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65197 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2GJGSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:18:03 -0400
Date: Mon, 9 Jul 2012 23:17:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ
 mapping
Message-ID: <20120710061757.GB29257@core.coreip.homeip.net>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
 <4FF6994B.9040801@linaro.org>
 <20120706173957.GA10202@core.coreip.homeip.net>
 <4FFB288D.4080606@linaro.org>
 <20120709201422.GA12242@core.coreip.homeip.net>
 <4FFB40A4.5060505@linaro.org>
 <20120709204620.GA12692@core.coreip.homeip.net>
 <4FFB463F.9040201@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFB463F.9040201@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 10:59:43PM +0200, Lee Jones wrote:
> Sorry for the cock-up(s).
> 
> From: Lee Jones <lee.jones@linaro.org>
> Date: Tue, 26 Jun 2012 10:46:50 +0100
> Subject: [PATCH 1/1] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
> 
> Before we can use any domain allocated IRQ, we need to first create a
> map between the Hardware IRQ (hwirq) and the Linux Virtual IRQ (virq).
> We do this with a helper function provided by the AB8500 IRQ domain
> controller called ab8500_irq_get_virq(). We need to do this for both
> IRQs which the Power-On-Key driver uses; one for button press, the other
> for button depress.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I think it would be best if this got merged through whatever tree that
was used to introduce ab8500_irq_get_virq(); otherwise it will have to
wait till I resync with mainline sometime in the middle of the next
release cycle.

Thanks.

> ---
>  drivers/input/misc/ab8500-ponkey.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
> index 5ceb23e..f6764af 100644
> --- a/drivers/input/misc/ab8500-ponkey.c
> +++ b/drivers/input/misc/ab8500-ponkey.c
> @@ -74,8 +74,8 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
>  
>  	ponkey->idev = input;
>  	ponkey->ab8500 = ab8500;
> -	ponkey->irq_dbf = irq_dbf;
> -	ponkey->irq_dbr = irq_dbr;
> +	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, irq_dbf);
> +	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, irq_dbr);
>  
>  	input->name = "AB8500 POn(PowerOn) Key";
>  	input->dev.parent = &pdev->dev;
> -- 
> 1.7.9.5
> 
> 
> 

-- 
Dmitry
