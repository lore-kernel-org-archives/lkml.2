Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2ATBmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:42:20 -0500
Received: from mail2.nsc.com ([12.238.8.132]:51347 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751620Ab2ATBmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:42:18 -0500
X-WSS-ID: 0LY2Q2E-0A-FC9-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Thu, 19 Jan 2012 17:42:03 -0800
Subject: RE: [PATCH] leds-lm3530: support pwm input mode and add
 platform data
Thread-Topic: [PATCH] leds-lm3530: support pwm input mode and add
 platform data
Thread-Index: AczW0+UiPOCryHn0RNCGvHnMoKVgJwAQJBJA
Message-ID: <B567DBAB974C0544994013492B949F8E3812C6D0C1@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812C6CB35@EXMAIL03.scwf.nsc.com>
 <CACRpkdZEKg1yAwYnJ+v9ZRM0hd2p5aOmVG4t3KbT7dc5MGNWxw@mail.gmail.com>
In-Reply-To: <CACRpkdZEKg1yAwYnJ+v9ZRM0hd2p5aOmVG4t3KbT7dc5MGNWxw@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630619E51LS9809845-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your advice.
OK, I'll re-patch them separately.

Best Regard,
Milo -

-----Original Message-----
From: Linus Walleij [mailto:linus.walleij@linaro.org] 
Sent: Friday, January 20, 2012 2:58 AM
To: Kim, Milo
Cc: shreshthakumar.sahu@stericsson.com; linux-kernel@vger.kernel.org; D.Murphy@motorola.com; rpurdie@rpsys.net
Subject: Re: [PATCH] leds-lm3530: support pwm input mode and add platform data

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

