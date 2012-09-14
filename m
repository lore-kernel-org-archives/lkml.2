Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139Ab2INWZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:25:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52595 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab2INWZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:25:01 -0400
MIME-Version: 1.0
In-Reply-To: <1347609183-26730-2-git-send-email-bryan.wu@canonical.com>
References: <1347609183-26730-1-git-send-email-bryan.wu@canonical.com>
	<1347609183-26730-2-git-send-email-bryan.wu@canonical.com>
Date: Fri, 14 Sep 2012 16:25:00 -0600
Message-ID: <CAKocOOOvOPYZnH0YK2jC2ze1=sQia2B1KcX6k0tviDDyf4vW=Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds: use workqueue in led_set_brightness() API internally
From: Shuah Khan <shuahkhan@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-leds@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        fabio.baltieri@gmail.com, raph@8d.com, tpiepho@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 1:53 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
> The API function led_set_brightness() and __led_set_brightness will
> call .brightness_set() function provided by led class drivers. So
> .brightness_set() function will run in atomic context, which requires
> led class drivers use workqueue in .brightness_set().
>
> Finally, all the led class driver implemented their own workqueue in
> .brightness_set(). For those missing this, we will face runtime warning
> or error when running it in atomic context.
>
> This patch adds a workqueue in led_set_brightness() internally. LED
> class driver doesn't need to care about duplicated workqueue stuff in
> their own driver.
>
> Also this patch unified the led_set_brightness() and __led_set_brightness()
>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/led-class.c          | 23 ++++++++++++-----------
>  drivers/leds/led-core.c           | 15 +++++++--------
>  drivers/leds/leds.h               | 11 ++---------
>  drivers/leds/ledtrig-backlight.c  |  8 ++++----
>  drivers/leds/ledtrig-default-on.c |  2 +-
>  drivers/leds/ledtrig-gpio.c       |  6 +++---
>  drivers/leds/ledtrig-heartbeat.c  |  2 +-
>  drivers/leds/ledtrig-oneshot.c    |  4 ++--
>  drivers/leds/ledtrig-transient.c  |  8 ++++----

Bryan,

ledtrig-transient.c change looks good. Thanks for updating it.

-- Shuah
