Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab2GFRkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:40:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785Ab2GFRkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:40:03 -0400
Date: Fri, 6 Jul 2012 10:39:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ
 mapping
Message-ID: <20120706173957.GA10202@core.coreip.homeip.net>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
 <4FF6994B.9040801@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF6994B.9040801@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Fri, Jul 06, 2012 at 08:52:43AM +0100, Lee Jones wrote:
> Sorry Dmitry, looks like I missed you off of the CC list on this one.
> 
> Here it is again:
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
> drivers/input/misc/ab8500-ponkey.c |    2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
> index 5ceb23e..ae4b683 100644
> --- a/drivers/input/misc/ab8500-ponkey.c
> +++ b/drivers/input/misc/ab8500-ponkey.c
> @@ -82,6 +82,7 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
>  	input_set_capability(input, EV_KEY, KEY_POWER);
> +	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, ponkey->irq_dbf);
> 	error = request_any_context_irq(ponkey->irq_dbf, ab8500_ponkey_handler,
> 					0, "ab8500-ponkey-dbf", ponkey);
> 	if (error < 0) {
> @@ -90,6 +91,7 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
> 		goto err_free_mem;
> 	}
> +	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, ponkey->irq_dbr);

I do not think this is right - you are storing irq_dbr in irq_dbf. Also,
I think you want to do this earlier, like this:

-	ponkey->irq_dbf = irq_dbf;
-	ponkey->irq_dbr = irq_dbr;
+	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, irq_dbf);
+	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, irq_dbr);

Thanks.

-- 
Dmitry
