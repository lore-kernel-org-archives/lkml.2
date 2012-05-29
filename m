Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2E2Bw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 21:52:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61510 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab2E2Bw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 21:52:56 -0400
MIME-Version: 1.0
In-Reply-To: <4FC39B5A.9010007@metasoft.pl>
References: <4FC39B5A.9010007@metasoft.pl>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 29 May 2012 09:52:34 +0800
X-Google-Sender-Auth: Z5fll8ZNKlkpazCoSLSc3KITaIY
Message-ID: <CAK5ve-+ZjD-QW-JipX_w67pZHU0NkSKrMgVhWBAeEuf5Zk2dww@mail.gmail.com>
Subject: Re: [PATCH] leds: don't disable blinking when writing the same value
 to delay_on or delay_off
To: Rafal Prylowski <prylowski@metasoft.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 11:35 PM, Rafal Prylowski <prylowski@metasoft.pl> wrote:
> Function led_set_software_blink() assumes that blink timer is still running,
> but commit 488bc35bf40df89d37486c1826b178a2fba36ce7 introduced disabling
> of blink timer before each call to led_set_software_blink().
>
> Correct led_software_blink():
> 1) remove protection against reprogramming blink timer to the same values,
>   because it only disables blinking now,
> 2) remove unnecessary call to led_stop_software_blink().
>

Fair enough. Applied to my fixed-for-3.5 branch.

Thanks,
-Bryan

> Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
> Cc: Bryan Wu <bryan.wu@canonical.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>
> Patch applies to current mainline.
>
>  drivers/leds/led-core.c |    7 -------
>  1 file changed, 7 deletions(-)
>
> Index: mainline/drivers/leds/led-core.c
> ===================================================================
> --- mainline.orig/drivers/leds/led-core.c
> +++ mainline/drivers/leds/led-core.c
> @@ -44,13 +44,6 @@ static void led_set_software_blink(struc
>        if (!led_cdev->blink_brightness)
>                led_cdev->blink_brightness = led_cdev->max_brightness;
>
> -       if (led_get_trigger_data(led_cdev) &&
> -           delay_on == led_cdev->blink_delay_on &&
> -           delay_off == led_cdev->blink_delay_off)
> -               return;
> -
> -       led_stop_software_blink(led_cdev);
> -
>        led_cdev->blink_delay_on = delay_on;
>        led_cdev->blink_delay_off = delay_off;
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
