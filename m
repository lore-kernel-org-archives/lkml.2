Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2FLGZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:25:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63631 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2FLGZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:25:46 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <000c01cd4766$b013b410$103b1c30$%han@samsung.com>
References: <000c01cd4766$b013b410$103b1c30$%han@samsung.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 12 Jun 2012 14:25:25 +0800
Message-ID: <CAF+7xW=UR4qXg9Pu4aMtHPYP6ATyvqwkW1wY=E2VvdmT6SAScQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3][RESEND] backlight: ot200_bl: use devm_ functions
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  error_mfgpt_alloc:
>        gpio_free(GPIO_DIMM);

You can also use devm_gpio_request, so you can remove gpio_free here
and remove the gpio_free in ot200_backlight_remove().

> @@ -141,7 +139,6 @@ error_mfgpt_alloc:
>  static int ot200_backlight_remove(struct platform_device *pdev)
>  {
>        struct backlight_device *bl = platform_get_drvdata(pdev);
> -       struct ot200_backlight_data *data = bl_get_data(bl);
>
>        backlight_device_unregister(bl);
>
> @@ -154,7 +151,6 @@ static int ot200_backlight_remove(struct platform_device *pdev)
>        cs5535_mfgpt_free_timer(pwm_timer);
>        gpio_free(GPIO_DIMM);
>
> -       kfree(data);
>        return 0;
>  }
