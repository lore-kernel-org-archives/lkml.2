Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab2KHMz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:55:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46735 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab2KHMz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:55:58 -0500
Message-ID: <509BABD8.5080600@ti.com>
Date: Thu, 8 Nov 2012 13:55:52 +0100
From: =?UTF-8?B?UMOpdGVyIFVqZmFsdXNp?= <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/3] pwm: New driver to support PWM driven LEDs on TWL4030/6030
 series of PMICs
References: <1352299488-11351-1-git-send-email-peter.ujfalusi@ti.com> <1352299488-11351-4-git-send-email-peter.ujfalusi@ti.com> <CANOLnONc29=cDZE=UXubs7DYOUWbgLJspPPVT2Hfq9E3zXkgVQ@mail.gmail.com> <509B6087.2040004@ti.com> <CANOLnONQf6HH4GbVo2M9RbMytS4GfihypU5grOvDRs8LyP+M6Q@mail.gmail.com>
In-Reply-To: <CANOLnONQf6HH4GbVo2M9RbMytS4GfihypU5grOvDRs8LyP+M6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 01:29 PM, Grazvydas Ignotas wrote:
>> But I want to note that I'm currently trying to clean up the mess around
>> twl-core. In my view we have quite a bit of redundancy in there. The PWM A/B
>> is for driving the LED A/B outputs. We should have only these modules for
>> PWM/LED in twl-core:
>> TWL_MODULE_PWM - offset for PWM0ON register in twl4030 and PWM1ON for twl6030
>> TWL_MODULE_LED - offset for LEDEN register in twl4030 and LED_PWM_CTRL1
>>                  for twl6030
>>
>> From here the driver can figure out what to do IMHO.
>>
>> There's no need to have separate TWL 'modules' for:
>> TWL4030_BASEADD_PWM0
>> TWL4030_BASEADD_PWM1
>> TWL4030_BASEADD_PWMA
>> TWL4030_BASEADD_PWMB
> 
> Well all these seem to come from TRM, no hard feelings here too but if
> you are going to remove them, probably worth adding a comment.

>From the 'outside' of twl4030 we have: LEDA, LEDB, PWM0 and PWM1 pins. This is
more important from system integration point of view than what name the TRM
calls the PWM (PWMA) behind of the LEDA terminal for example.

At the end in the board file you will have to use something like this:

static struct pwm_lookup zoom_pwm_lookup[] = {
	PWM_LOOKUP("twl-pwm", 0, "leds_pwm", "zoom::keypad"),       /* PWM0 */
	PWM_LOOKUP("twl-pwm", 1, "pwm-backlight", "backlight"),     /* PWM1 */
	PWM_LOOKUP("twl-pwm-led", 0, "leds_pwm", "zoom::blinking"), /* LEDA */
};

I'll add comment to both the pwm-twl and pwm-twl-led driver for clarification.

-- 
Péter
