Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab2GFV2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:28:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab2GFV2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:28:30 -0400
Message-ID: <4FF7586B.9080902@redhat.com>
Date: Fri, 06 Jul 2012 18:28:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Du, Changbin" <changbin.du@gmail.com>
CC: mchehab@infradead.org, anssi.hannula@iki.fi, gregkh@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] media: gpio-ir-recv: add allowed_protos for platform
 data
References: <4ff3b46c.06da440a.6345.ffff8730@mx.google.com>
In-Reply-To: <4ff3b46c.06da440a.6345.ffff8730@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-07-2012 00:11, Du, Changbin escreveu:
> Make it possible to specify allowed RC protocols through the device's
> platform data.
> 
> Signed-off-by: Du, Changbin <changbin.du@gmail.com>

Gah, you trapped me: you've resent it, without using the original message ID.

Too late. I'll keep the version where I've fixed the merge
conflict, as it does the same thing.

Regards,
Mauro.

> ---
> For v2:
> 	Keymap has already done by another patch.
> ---
>   drivers/media/rc/gpio-ir-recv.c |    2 +-
>   include/media/gpio-ir-recv.h    |    7 ++++---
>   2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/rc/gpio-ir-recv.c
> b/drivers/media/rc/gpio-ir-recv.c
> index 59fe60c..38da91e 100644
> --- a/drivers/media/rc/gpio-ir-recv.c
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -84,7 +84,7 @@ static int __devinit gpio_ir_recv_probe(struct
> platform_device *pdev)
>   
>   	rcdev->priv = gpio_dev;
>   	rcdev->driver_type = RC_DRIVER_IR_RAW;
> -	rcdev->allowed_protos = RC_TYPE_ALL;
> +	rcdev->allowed_protos = pdata->allowed_protos ?: RC_TYPE_ALL;
>   	rcdev->input_name = GPIO_IR_DEVICE_NAME;
>   	rcdev->input_phys = GPIO_IR_DEVICE_NAME "/input0";
>   	rcdev->input_id.bustype = BUS_HOST;
> diff --git a/include/media/gpio-ir-recv.h b/include/media/gpio-ir-recv.h
> index 91546f3..0142736 100644
> --- a/include/media/gpio-ir-recv.h
> +++ b/include/media/gpio-ir-recv.h
> @@ -14,9 +14,10 @@
>   #define __GPIO_IR_RECV_H__
>   
>   struct gpio_ir_recv_platform_data {
> -	int gpio_nr;
> -	bool active_low;
> -	const char *map_name;
> +	int		gpio_nr;
> +	bool		active_low;
> +	u64		allowed_protos;
> +	const char	*map_name;
>   };
>   
>   #endif /* __GPIO_IR_RECV_H__ */
> 


