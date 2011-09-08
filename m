Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1IHXLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:11:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45893 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1IHXLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:11:05 -0400
MIME-Version: 1.0
In-Reply-To: <1315259762-9034-1-git-send-email-bryan.wu@canonical.com>
References: <1315259762-9034-1-git-send-email-bryan.wu@canonical.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 9 Sep 2011 06:41:27 +0800
X-Google-Sender-Auth: U9his4Z7FOCoUHAI-aeEYwpd9WA
Message-ID: <CAK5ve-+B0kUWUEOzeBA-nrCTSumk7Tys542HtH7zTt0PjzF2GQ@mail.gmail.com>
Subject: Re: [PATCH v2] leds: set LEDS_TRIGGERS as tristate
To: rpurdie@rpsys.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard,

How do you think this patch, I think we need this after we change
LEDS_CLASS back to tristate.

Thanks,
-Bryan

On Tue, Sep 6, 2011 at 5:56 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
> LEDS_TRIGGERS is depends on LEDS_CLASSS, which should be tristate. So
> set it as tristate too and update header files as well.
>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/Kconfig |    2 +-
>  drivers/leds/leds.h  |    2 +-
>  include/linux/leds.h |    7 ++++---
>  3 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 1c35927..0238719 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -387,7 +387,7 @@ config LEDS_ASIC3
>          period from 62ms to 125s. Say Y to enable LEDs on the HP iPAQ hx4700.
>
>  config LEDS_TRIGGERS
> -       bool "LED Trigger support"
> +       tristate "LED Trigger support"
>        depends on LEDS_CLASS
>        help
>          This option enables trigger support for the leds class.
> diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
> index e77c7f8..53b59b7 100644
> --- a/drivers/leds/leds.h
> +++ b/drivers/leds/leds.h
> @@ -35,7 +35,7 @@ static inline int led_get_brightness(struct led_classdev *led_cdev)
>  extern struct rw_semaphore leds_list_lock;
>  extern struct list_head leds_list;
>
> -#ifdef CONFIG_LEDS_TRIGGERS
> +#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
>  void led_trigger_set_default(struct led_classdev *led_cdev);
>  void led_trigger_set(struct led_classdev *led_cdev,
>                        struct led_trigger *trigger);
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 5884def..051bc7e 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -66,7 +66,7 @@ struct led_classdev {
>        struct timer_list        blink_timer;
>        int                      blink_brightness;
>
> -#ifdef CONFIG_LEDS_TRIGGERS
> +#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
>        /* Protects the trigger data below */
>        struct rw_semaphore      trigger_lock;
>
> @@ -115,7 +115,7 @@ extern void led_brightness_set(struct led_classdev *led_cdev,
>  /*
>  * LED Triggers
>  */
> -#ifdef CONFIG_LEDS_TRIGGERS
> +#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
>
>  #define TRIG_NAME_MAX 50
>
> @@ -161,7 +161,8 @@ extern void led_trigger_blink(struct led_trigger *trigger,
>  #endif
>
>  /* Trigger specific functions */
> -#ifdef CONFIG_LEDS_TRIGGER_IDE_DISK
> +#if defined(CONFIG_LEDS_TRIGGER_IDE_DISK) || \
> +       defined(CONFIG_LEDS_TRIGGER_IDE_DISK_MODULE)
>  extern void ledtrig_ide_activity(void);
>  #else
>  #define ledtrig_ide_activity() do {} while(0)
> --
> 1.7.4.1
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
