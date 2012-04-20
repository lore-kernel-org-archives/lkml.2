Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2DTVeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:34:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2DTVe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:34:29 -0400
Date: Fri, 20 Apr 2012 14:34:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net,
        plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH 10/12] leds-atmel-pwm.c: Make pwmled_probe() __devinit
Message-Id: <20120420143427.97c08ee5.akpm@linux-foundation.org>
In-Reply-To: <23f8dba8a3e1ae21a5953747b63dc0a21fcba868.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
	<23f8dba8a3e1ae21a5953747b63dc0a21fcba868.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 11:20:54 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> Commit 892a884 (leds: convert led platform drivers to module_platform_driver)
> is omitting the section mismatch error: so change annotation of the probe
> function to __devinit instead of __init.
> 
> ...
>
> --- a/drivers/leds/leds-atmel-pwm.c
> +++ b/drivers/leds/leds-atmel-pwm.c
> @@ -35,7 +35,7 @@ static void pwmled_brightness(struct led_classdev *cdev, enum led_brightness b)
>   * NOTE:  we reuse the platform_data structure of GPIO leds,
>   * but repurpose its "gpio" number as a PWM channel number.
>   */
> -static int __init pwmled_probe(struct platform_device *pdev)
> +static int __devinit pwmled_probe(struct platform_device *pdev)
>  {
>  	const struct gpio_led_platform_data	*pdata;
>  	struct pwmled				*leds;

This is theoretically oopsable and the patch is probably needed in 3.4
and 3.3.x.

But you've applied it to linu-next via your own tree so I won't be
merging it.
