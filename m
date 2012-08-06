Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2HFPTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:19:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50988 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2HFPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:19:22 -0400
Date: Mon, 6 Aug 2012 01:19:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120806081915.GA4518@core.coreip.homeip.net>
References: <1344256323-10484-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344256323-10484-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Aug 06, 2012 at 01:32:03PM +0100, Lee Jones wrote:
> If we're booting with Device Tree enabled, we want the IRQ numbers to
> be taken and translated from the Device Tree binary. If not, they
> should be taken from the resource allocation defined in the AB8500 MFD
> core driver.
> 
> Tested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/input/misc/ab8500-ponkey.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
> index 1a1d974..afcd87f 100644
> --- a/drivers/input/misc/ab8500-ponkey.c
> +++ b/drivers/input/misc/ab8500-ponkey.c
> @@ -47,6 +47,7 @@ static irqreturn_t ab8500_ponkey_handler(int irq, void *data)
>  static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
>  {
>  	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
> +	struct device_node *np = pdev->dev.of_node;
>  	struct ab8500_ponkey *ponkey;
>  	struct input_dev *input;
>  	int irq_dbf, irq_dbr;
> @@ -73,8 +74,9 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
>  
>  	ponkey->idev = input;
>  	ponkey->ab8500 = ab8500;
> -	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, irq_dbf);
> -	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, irq_dbr);
> +
> +	ponkey->irq_dbf = (np) ? ab8500_irq_get_virq(ab8500, irq_dbf) : irq_dbf;
> +	ponkey->irq_dbr = (np) ? ab8500_irq_get_virq(ab8500, irq_dbr) : irq_dbr;

Why this isn't done inside ab8500_irq_get_virq()?

Thanks.

-- 
Dmitry
