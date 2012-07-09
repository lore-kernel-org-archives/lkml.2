Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab2GIUO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:14:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60750 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2GIUO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:14:28 -0400
Date: Mon, 9 Jul 2012 13:14:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ
 mapping
Message-ID: <20120709201422.GA12242@core.coreip.homeip.net>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
 <4FF6994B.9040801@linaro.org>
 <20120706173957.GA10202@core.coreip.homeip.net>
 <4FFB288D.4080606@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFB288D.4080606@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 08:53:01PM +0200, Lee Jones wrote:
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
> ---
>  drivers/input/misc/ab8500-ponkey.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
> index 5ceb23e..08d42d1 100644
> --- a/drivers/input/misc/ab8500-ponkey.c
> +++ b/drivers/input/misc/ab8500-ponkey.c
> @@ -82,6 +82,7 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
>  
>  	input_set_capability(input, EV_KEY, KEY_POWER);
>  
> +	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, ponkey->irq_dbf);

*sigh*

Can we please do the assignment earlier? Look, we have a few lines
above:

	ponkey->idev = input;
	ponkey->ab8500 = ab8500;
	ponkey->irq_dbf = irq_dbf;
	ponkey->irq_dbr = irq_dbr;

Why do you keep these assignments and then override them with
translations? Why don't you do

	ponkey->idev = input;
	ponkey->ab8500 = ab8500;
	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, irq_dbf);
	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, irq_dbr);

to begin with?

Thanks.

-- 
Dmitry
