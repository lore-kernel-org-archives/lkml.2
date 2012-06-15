Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab2FOEPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 00:15:04 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54028 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2FOEPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 00:15:01 -0400
MIME-Version: 1.0
In-Reply-To: <1339698815-1806-1-git-send-email-fabio.baltieri@gmail.com>
References: <1339619670.13326.22.camel@lorien2> <1339698815-1806-1-git-send-email-fabio.baltieri@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 15 Jun 2012 12:14:40 +0800
X-Google-Sender-Auth: iFC2XwoEvK24IK2bhA7oSDm12Y8
Message-ID: <CAK5ve-KM68yfZyFxQ73nJcq2TcgjvWcRymSMHM2yLufXftLzaQ@mail.gmail.com>
Subject: Re: [PATCH v2] leds: use led_set_brightness in led_trigger_event
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 2:33 AM, Fabio Baltieri
<fabio.baltieri@gmail.com> wrote:
> Fix led_trigger_event() to use led_set_brightness() instead of
> __led_set_brightness(), so that any pending blink timer is stopped before
> setting the new brightness value.  Without this fix LED status may be
> overridden by a pending timer.
>
> This allows a trigger to use a mix of led_trigger_event(),
> led_trigger_blink() and led_trigger_blink_oneshot() without races.
>
> (applied over: leds: Rename led_brightness_set() to led_set_brightness())
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> Cc: Shuah Khan <shuahkhan@gmail.com>
> Cc: Bryan Wu <bryan.wu@canonical.com>

Thanks, applied to for-next branch on top of Shuah's renaming patch.

-Bryan

> ---
>
> Hi Shuah,
>
> thanks for the renaming, looks much more clear now, so that's my
> led_trigger_event patch which applies on top of your latest patch - which
> should still be needed if I didn't lost anything.
>
> Fabio
>
>  drivers/leds/led-triggers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index 57721f2..de1c59d 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -224,7 +224,7 @@ void led_trigger_event(struct led_trigger *trig,
>                struct led_classdev *led_cdev;
>
>                led_cdev = list_entry(entry, struct led_classdev, trig_list);
> -               __led_set_brightness(led_cdev, brightness);
> +               led_set_brightness(led_cdev, brightness);
>        }
>        read_unlock(&trig->leddev_list_lock);
>  }
> --
> 1.7.11.rc1.9.gf623ca1.dirty
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
