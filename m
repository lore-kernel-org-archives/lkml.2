Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab2FME0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 00:26:14 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58846 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2FME0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 00:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <1339552897.6436.5.camel@lorien2>
References: <1339448260-1733-1-git-send-email-fabio.baltieri@gmail.com>
 <1339450705.23857.16.camel@lorien2> <20120612071649.GA1306@gmail.com>
 <CAK5ve-+D7vPO1U4gZDHRBmafJtF5T_EYBPCSAT2YOXjbc_u4zQ@mail.gmail.com>
 <1339521308.2628.13.camel@lorien2> <1339552897.6436.5.camel@lorien2>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 13 Jun 2012 12:25:51 +0800
X-Google-Sender-Auth: cSUNR9rT65oF6H2Z1bQcsDbkyRs
Message-ID: <CAK5ve-J-H2VYYa7SjJwP=1=K0K-wTFNWUDf93DRm1pLPAPx03Q@mail.gmail.com>
Subject: Re: [PATCH] leds: Rename led_set_brightness() to __led_set_brightness()
To: shuahkhan@gmail.com
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 10:01 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
> Rename leds internal interface led_set_brightness() to __led_set_brightness()
> to reduce confusion between led_set_brightness() and the external interface
> led_brightness_set(). led_brightness_set() cancels the timer and then calls
> led_set_brightness().
>
>
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> ---
>
> Bryan,
>
> This is the first patch that renames led_set_brightness() to __led_set_brightness().
> Will send another patch that renames led_brightness_set() to led_set_brightness().
>
> -- Shuah

OK, thanks, applied to devel and for-next

>
>
>  drivers/leds/led-class.c          |    6 +++---
>  drivers/leds/led-core.c           |    4 ++--
>  drivers/leds/led-triggers.c       |    2 +-
>  drivers/leds/leds.h               |    2 +-
>  drivers/leds/ledtrig-backlight.c  |    8 ++++----
>  drivers/leds/ledtrig-default-on.c |    2 +-
>  drivers/leds/ledtrig-gpio.c       |    6 +++---
>  drivers/leds/ledtrig-heartbeat.c  |    2 +-
>  drivers/leds/ledtrig-oneshot.c    |    4 ++--
>  drivers/leds/ledtrig-transient.c  |    8 ++++----
>  10 files changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 81eb091..cb0a6eb 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -53,7 +53,7 @@ static ssize_t led_brightness_store(struct device *dev,
>
>        if (state == LED_OFF)
>                led_trigger_remove(led_cdev);
> -       led_set_brightness(led_cdev, state);
> +       __led_set_brightness(led_cdev, state);
>
>        return size;
>  }
> @@ -82,7 +82,7 @@ static void led_timer_function(unsigned long data)
>        unsigned long delay;
>
>        if (!led_cdev->blink_delay_on || !led_cdev->blink_delay_off) {
> -               led_set_brightness(led_cdev, LED_OFF);
> +               __led_set_brightness(led_cdev, LED_OFF);
>                return;
>        }
>
> @@ -105,7 +105,7 @@ static void led_timer_function(unsigned long data)
>                delay = led_cdev->blink_delay_off;
>        }
>
> -       led_set_brightness(led_cdev, brightness);
> +       __led_set_brightness(led_cdev, brightness);
>
>        /* Return in next iteration if led is in one-shot mode and we are in
>         * the final blink state so that the led is toggled each delay_on +
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index 31f1f78..176961b 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -45,7 +45,7 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
>
>        /* never off - just set to brightness */
>        if (!delay_off) {
> -               led_set_brightness(led_cdev, led_cdev->blink_brightness);
> +               __led_set_brightness(led_cdev, led_cdev->blink_brightness);
>                return;
>        }
>
> @@ -111,6 +111,6 @@ void led_brightness_set(struct led_classdev *led_cdev,
>        led_cdev->blink_delay_on = 0;
>        led_cdev->blink_delay_off = 0;
>
> -       led_set_brightness(led_cdev, brightness);
> +       __led_set_brightness(led_cdev, brightness);
>  }
>  EXPORT_SYMBOL(led_brightness_set);
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index fa0b9be..f8b14dd 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -224,7 +224,7 @@ void led_trigger_event(struct led_trigger *trig,
>                struct led_classdev *led_cdev;
>
>                led_cdev = list_entry(entry, struct led_classdev, trig_list);
> -               led_set_brightness(led_cdev, brightness);
> +               __led_set_brightness(led_cdev, brightness);
>        }
>        read_unlock(&trig->leddev_list_lock);
>  }
> diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
> index e77c7f8..d02acd4 100644
> --- a/drivers/leds/leds.h
> +++ b/drivers/leds/leds.h
> @@ -17,7 +17,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/leds.h>
>
> -static inline void led_set_brightness(struct led_classdev *led_cdev,
> +static inline void __led_set_brightness(struct led_classdev *led_cdev,
>                                        enum led_brightness value)
>  {
>        if (value > led_cdev->max_brightness)
> diff --git a/drivers/leds/ledtrig-backlight.c b/drivers/leds/ledtrig-backlight.c
> index e272686..b941685 100644
> --- a/drivers/leds/ledtrig-backlight.c
> +++ b/drivers/leds/ledtrig-backlight.c
> @@ -46,9 +46,9 @@ static int fb_notifier_callback(struct notifier_block *p,
>
>                if ((n->old_status == UNBLANK) ^ n->invert) {
>                        n->brightness = led->brightness;
> -                       led_set_brightness(led, LED_OFF);
> +                       __led_set_brightness(led, LED_OFF);
>                } else {
> -                       led_set_brightness(led, n->brightness);
> +                       __led_set_brightness(led, n->brightness);
>                }
>
>                n->old_status = new_status;
> @@ -87,9 +87,9 @@ static ssize_t bl_trig_invert_store(struct device *dev,
>
>        /* After inverting, we need to update the LED. */
>        if ((n->old_status == BLANK) ^ n->invert)
> -               led_set_brightness(led, LED_OFF);
> +               __led_set_brightness(led, LED_OFF);
>        else
> -               led_set_brightness(led, n->brightness);
> +               __led_set_brightness(led, n->brightness);
>
>        return num;
>  }
> diff --git a/drivers/leds/ledtrig-default-on.c b/drivers/leds/ledtrig-default-on.c
> index a4ef54b..eac1f1b 100644
> --- a/drivers/leds/ledtrig-default-on.c
> +++ b/drivers/leds/ledtrig-default-on.c
> @@ -19,7 +19,7 @@
>
>  static void defon_trig_activate(struct led_classdev *led_cdev)
>  {
> -       led_set_brightness(led_cdev, led_cdev->max_brightness);
> +       __led_set_brightness(led_cdev, led_cdev->max_brightness);
>  }
>
>  static struct led_trigger defon_led_trigger = {
> diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
> index f057c10..ba215dc 100644
> --- a/drivers/leds/ledtrig-gpio.c
> +++ b/drivers/leds/ledtrig-gpio.c
> @@ -54,12 +54,12 @@ static void gpio_trig_work(struct work_struct *work)
>
>        if (tmp) {
>                if (gpio_data->desired_brightness)
> -                       led_set_brightness(gpio_data->led,
> +                       __led_set_brightness(gpio_data->led,
>                                           gpio_data->desired_brightness);
>                else
> -                       led_set_brightness(gpio_data->led, LED_FULL);
> +                       __led_set_brightness(gpio_data->led, LED_FULL);
>        } else {
> -               led_set_brightness(gpio_data->led, LED_OFF);
> +               __led_set_brightness(gpio_data->led, LED_OFF);
>        }
>  }
>
> diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
> index 41dc76d..d3039f2 100644
> --- a/drivers/leds/ledtrig-heartbeat.c
> +++ b/drivers/leds/ledtrig-heartbeat.c
> @@ -67,7 +67,7 @@ static void led_heartbeat_function(unsigned long data)
>                break;
>        }
>
> -       led_set_brightness(led_cdev, brightness);
> +       __led_set_brightness(led_cdev, brightness);
>        mod_timer(&heartbeat_data->timer, jiffies + delay);
>  }
>
> diff --git a/drivers/leds/ledtrig-oneshot.c b/drivers/leds/ledtrig-oneshot.c
> index 5c9edf7..5cbab41 100644
> --- a/drivers/leds/ledtrig-oneshot.c
> +++ b/drivers/leds/ledtrig-oneshot.c
> @@ -63,9 +63,9 @@ static ssize_t led_invert_store(struct device *dev,
>        oneshot_data->invert = !!state;
>
>        if (oneshot_data->invert)
> -               led_set_brightness(led_cdev, LED_FULL);
> +               __led_set_brightness(led_cdev, LED_FULL);
>        else
> -               led_set_brightness(led_cdev, LED_OFF);
> +               __led_set_brightness(led_cdev, LED_OFF);
>
>        return size;
>  }
> diff --git a/drivers/leds/ledtrig-transient.c b/drivers/leds/ledtrig-transient.c
> index 83179f4..398f104 100644
> --- a/drivers/leds/ledtrig-transient.c
> +++ b/drivers/leds/ledtrig-transient.c
> @@ -41,7 +41,7 @@ static void transient_timer_function(unsigned long data)
>        struct transient_trig_data *transient_data = led_cdev->trigger_data;
>
>        transient_data->activate = 0;
> -       led_set_brightness(led_cdev, transient_data->restore_state);
> +       __led_set_brightness(led_cdev, transient_data->restore_state);
>  }
>
>  static ssize_t transient_activate_show(struct device *dev,
> @@ -72,7 +72,7 @@ static ssize_t transient_activate_store(struct device *dev,
>        if (state == 0 && transient_data->activate == 1) {
>                del_timer(&transient_data->timer);
>                transient_data->activate = state;
> -               led_set_brightness(led_cdev, transient_data->restore_state);
> +               __led_set_brightness(led_cdev, transient_data->restore_state);
>                return size;
>        }
>
> @@ -80,7 +80,7 @@ static ssize_t transient_activate_store(struct device *dev,
>        if (state == 1 && transient_data->activate == 0 &&
>            transient_data->duration != 0) {
>                transient_data->activate = state;
> -               led_set_brightness(led_cdev, transient_data->state);
> +               __led_set_brightness(led_cdev, transient_data->state);
>                transient_data->restore_state =
>                    (transient_data->state == LED_FULL) ? LED_OFF : LED_FULL;
>                mod_timer(&transient_data->timer,
> @@ -203,7 +203,7 @@ static void transient_trig_deactivate(struct led_classdev *led_cdev)
>
>        if (led_cdev->activated) {
>                del_timer_sync(&transient_data->timer);
> -               led_set_brightness(led_cdev, transient_data->restore_state);
> +               __led_set_brightness(led_cdev, transient_data->restore_state);
>                device_remove_file(led_cdev->dev, &dev_attr_activate);
>                device_remove_file(led_cdev->dev, &dev_attr_duration);
>                device_remove_file(led_cdev->dev, &dev_attr_state);
> --
> 1.7.9.5
>
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
