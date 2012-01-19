Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab2ASR6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:58:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49980 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab2ASR6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:58:03 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812C6CB35@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812C6CB35@EXMAIL03.scwf.nsc.com>
Date: Thu, 19 Jan 2012 18:58:02 +0100
Message-ID: <CACRpkdZEKg1yAwYnJ+v9ZRM0hd2p5aOmVG4t3KbT7dc5MGNWxw@mail.gmail.com>
Subject: Re: [PATCH] leds-lm3530: support pwm input mode and add platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "D.Murphy@motorola.com" <D.Murphy@motorola.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 5:36 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> (a) support pwm control mode
>  (1) add 'struct lm3530_pwm_data' in the platform data
>  The pwm data is the platform specific functions which generate the pwm.
>  The pwm data is only valid when brightness is pwm input mode.
>  Functions should be implemented by the pwm driver.
>  pwm_set_intensity() : set duty of pwm.
>  pwm_get_intensity() : get current duty of pwm.
>
>  (2) brightness control by pwm
>  If the control mode is pwm, then brightness is changed by the duty of pwm.
>  So pwm platform function should be called in lm3530_brightness_set().
>
>  (3) do not update brightness register when pwm input mode
>  In pwm input mode, brightness register is not used.
>  If any value is updated in this register, then the led will be off.
>
> (b) add 'name' in the lm3530_platform_data
>  : The led device name can be configurable.
>  For the compatibility, the name is set to default value(LM3530_LED_DEV)
>  when 'name' is not defined.
>
> (c) add 'is_vin_always_on' in the lm3530_platform_data
>  : The 'IN' pin(Input voltage connection) can be always turned on
>  in case it is connected with VBATT.
>  To support this case, 'is_vin_always_on' is added.
>  If VIN is always on, then we don't need to control the regulator for IN pin.
>
> (d) add 'lm3530_mode_get()' in the lm3530 device attribute
>  : To get information about brightness control mode.
>
> (e) use 'struct led_classdev' rather than 'struct i2c_client'
>  to get members of lm3530_data
>  : in lm3530_mode_set()
>
> (f) use 'pdata' rather than 'pltfm' in lm3530_init_registers()
>
> (g) for less arithmetic operation, replace 'divide-by-2' with
>  'shift-right-by 1 bit'
>  : in lm3530_brightness_set()

Very nice patch, but please split it into one patch per subject
(a) through (g) as per Documentation/SubmittingPatches,
this makes it easier to review and git bisect.

Yours,
Linus Walleij
