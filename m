Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2KTLyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:54:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47004 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2KTLyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:54:18 -0500
Message-ID: <50AB6F63.9040009@ti.com>
Date: Tue, 20 Nov 2012 12:54:11 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 3/3] pwm: New driver to support PWM driven LEDs on
 TWL4030/6030 series of PMICs
References: <1353405382-9226-1-git-send-email-peter.ujfalusi@ti.com> <1353405382-9226-4-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1353405382-9226-4-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 10:56 AM, Peter Ujfalusi wrote:
> The driver supports the following LED outputs as generic PWM driver:
> TWL4030 LEDA and LEDB (PWMA and PWMB)
> TWL6030 Charging indicator LED (PWM LED)
> 
> On TWL6030 when the PWM requested LED is configured to be controlled by SW.
> In this case the user can enable/disable and set the duty period freely.
> When the PWM has been freed, the LED driver is put back to HW control.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/pwm/Kconfig       |  10 ++
>  drivers/pwm/Makefile      |   1 +
>  drivers/pwm/pwm-twl-led.c | 303 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 314 insertions(+)
>  create mode 100644 drivers/pwm/pwm-twl-led.c

...

> +static int twl4030_pwmled_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			      int duty_ns, int period_ns)
> +{
> +	int duty_cycle = DIV_ROUND_UP(duty_ns * TWL4030_LED_MAX, period_ns);
> +	u8 pwm_config[2] = {1, 0};
> +	int base, ret;
> +
> +	/*
> +	 * To configure the duty period:
> +	 * On-cycle is set to 1 (the minimum allowed value)
> +	 * The off time of 0 is not configurable, so the mapping is:
> +	 * 0 -> off cycle = 2,
> +	 * 1 -> off cycle = 2,
> +	 * 2 -> off cycle = 3,
> +	 * 125 - > off cycle 127,
> +	 * 126 - > off cycle 1

Oh, I missed to save the updated comment before I commited the change.
Can I just send and update patch instead of the whole series again?

> +	 * When on cycle == off cycle the PWM will be always on
> +	 */


-- 
Péter
