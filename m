Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2KZIaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:30:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41792 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab2KZIaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:30:10 -0500
Message-ID: <50B3288B.5020500@ti.com>
Date: Mon, 26 Nov 2012 09:30:03 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 3/3] pwm: New driver to support PWM driven LEDs on
 TWL4030/6030 series of PMICs
References: <1353405382-9226-1-git-send-email-peter.ujfalusi@ti.com> <1353405382-9226-4-git-send-email-peter.ujfalusi@ti.com> <20121123150412.GB16810@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121123150412.GB16810@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 04:04 PM, Thierry Reding wrote:
> On Tue, Nov 20, 2012 at 10:56:22AM +0100, Peter Ujfalusi wrote:
>> The driver supports the following LED outputs as generic PWM driver:
>> TWL4030 LEDA and LEDB (PWMA and PWMB)
>> TWL6030 Charging indicator LED (PWM LED)
>>
>> On TWL6030 when the PWM requested LED is configured to be controlled by SW.
>> In this case the user can enable/disable and set the duty period freely.
>> When the PWM has been freed, the LED driver is put back to HW control.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>  drivers/pwm/Kconfig       |  10 ++
>>  drivers/pwm/Makefile      |   1 +
>>  drivers/pwm/pwm-twl-led.c | 303 ++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 314 insertions(+)
>>  create mode 100644 drivers/pwm/pwm-twl-led.c
> 
> Doesn't this belong in the drivers/leds subsystem? Besides that, the
> same comments as for the previous patch apply. One additional note
> below.

The PINs itself are called as LED but they are PWMs at the end. If we
represent them as PWMs they can be used for different purposes which is going
to be needed for example in BeagleBoard, where the LEDA (PWMA) is used as a
GPO to enable/disable the USB host power.
Also the removed 'twl6030-pwm' driver was only controlled the LED part of twl6030.
With this series I enable the use of the PWMs and the PWMs behind of the LED
functions to give us flexibility on how we are using them.

> 
>> +static struct platform_driver twl_pwmled_driver = {
>> +	.driver = {
>> +		.name = "twl-pwmled",
>> +		.of_match_table = of_match_ptr(twl_pwmled_of_match),
>> +	},
>> +	.probe = twl_pwmled_probe,
>> +	.remove = __devexit_p(twl_pwmled_remove),
> 
> You didn't annotate twl_pwmled_remove() with __devexit, so __devexit_p
> isn't needed here either.

Oh yes, I have also received patches from a series which removes the
_devexit_p() from the kernel.
But should the __devexit need to be added to the remove function?

-- 
Péter
