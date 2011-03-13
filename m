Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1CMGpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:45:15 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:47810 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1CMGpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:45:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZcLcfW60CAN59gB0R6rUkXE/2yKlfC56lsuuT4hS4ZUCyNrisOgneBbc2tO2EkYOmQ
         eZTBXv+XzOzx9U1KshhE/Te+NBP0aqePAAybLmkWb9i/5D0ZmxnZF17KSGJrIoBgFPqH
         zp9YEXbFL5zfhasaf1dQuQTyrChFdSrCKlar4=
Date: Sat, 12 Mar 2011 22:45:07 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: set the long press detection in 88pm860x onkey
Message-ID: <20110313064507.GH31566@core.coreip.homeip.net>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-7-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-8-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-9-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-10-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299512600-29047-10-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:43:18PM +0800, Haojian Zhuang wrote:
> Move the long-press detection from onkey handler to probe function. Avoid
> unnecessary I2C operation in onkey handler.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

> ---
>  drivers/input/misc/88pm860x_onkey.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/misc/88pm860x_onkey.c b/drivers/input/misc/88pm860x_onkey.c
> index 3dca3c1..1abc77e 100644
> --- a/drivers/input/misc/88pm860x_onkey.c
> +++ b/drivers/input/misc/88pm860x_onkey.c
> @@ -50,9 +50,6 @@ static irqreturn_t pm860x_onkey_handler(int irq, void *data)
>  	ret &= ONKEY_STATUS;
>  	input_report_key(info->idev, KEY_POWER, ret);
>  	input_sync(info->idev);
> -
> -	/* Enable 8-second long onkey detection */
> -	pm860x_set_bits(info->i2c, PM8607_WAKEUP, 3, LONG_ONKEY_EN);
>  	return IRQ_HANDLED;
>  }
>  
> @@ -105,6 +102,9 @@ static int __devinit pm860x_onkey_probe(struct platform_device *pdev)
>  	}
>  
>  	platform_set_drvdata(pdev, info);
> +
> +	/* Enable 8-second long onkey detection */
> +	pm860x_set_bits(info->i2c, PM8607_WAKEUP, 3, LONG_ONKEY_EN);
>  	return 0;
>  
>  out_irq:
> -- 
> 1.5.6.5
> 

-- 
Dmitry
