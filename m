Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2AWTNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:13:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36557 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2AWTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:13:19 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812C6D0CD@EXMAIL03.scwf.nsc.com>
References: <AczXFZjmtQHOiXDCSJi9Lr1dSJlaCQ==>
	<B567DBAB974C0544994013492B949F8E3812C6D0CD@EXMAIL03.scwf.nsc.com>
Date: Mon, 23 Jan 2012 20:13:18 +0100
Message-ID: <CACRpkdbyK3eevSu3JeTzWguhJkSAm+8vmxymV03UhxhNQUtVsw@mail.gmail.com>
Subject: Re: [PATCH 3/7] leds-lm3530: add 'is_vin_always_on' in the lm3530_platform_data
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 2:48 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> The 'IN' pin(Input voltage connection) can be always turned on
> in case it is connected with VBATT.
> To support this case, 'is_vin_always_on' is added.
> If VIN is always on, then we don't need to control the regulator for IN pin.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
(...)
> +       if (!drvdata->enable && !pltfm->is_vin_always_on) {
>                ret = regulator_enable(drvdata->regulator);
>                if (ret) {
>                        dev_err(&drvdata->client->dev,
> @@ -256,7 +256,7 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
>                else
>                        drvdata->brightness = brt_val / 2;
>
> -               if (brt_val == 0) {
> +               if (brt_val == 0 && !pdata->is_vin_always_on) {
>                        err = regulator_disable(drvdata->regulator);

NACK on this, and paging Mark.

As far as I know we want to get rid of different design patterns
avoiding the regulator interface. The way forward for this is
either:

(A) Provide a fixed voltage regulator in your platform for this
  device (AFAIK the voltage does not even have to be correct)
(B) Enable dummy regulators in your platform

(A) is more elegant.

Yours,
Linus Walleij
