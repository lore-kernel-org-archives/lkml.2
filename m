Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2KSIwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:52:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56353 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab2KSIwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:52:09 -0500
Message-ID: <50A9F335.80107@ti.com>
Date: Mon, 19 Nov 2012 09:52:05 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: twl4030: Use only TWL4030_MODULE_LED for LED configuration
References: <1352799313-21019-1-git-send-email-peter.ujfalusi@ti.com> <CACRpkdayZK2sPXJW=COFi7C=P5=fbi-q7UukWbQ8dheaJ=bjAA@mail.gmail.com>
In-Reply-To: <CACRpkdayZK2sPXJW=COFi7C=P5=fbi-q7UukWbQ8dheaJ=bjAA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 11/17/2012 09:16 PM, Linus Walleij wrote:
> On Tue, Nov 13, 2012 at 10:35 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> 
>> Avoid using the TWL4030_MODULE_PWMA/B as module ID. The LEDEN, PWMA ON/OFF
>> and PWMB ON/OFF registers are in a continuous range starting from LED base.
>> This is going to be helpful for further cleanup in the twl stack.
>>
>> No functional changes.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> OK if you say so.
> 
> Patch applied!

Thanks,

I was actually tempted to remove the whole LED (PWM) thing from the
gpio-twl4030 driver. It was a big surprise to me to see something like this in
there.
It turns out that on BeagleBoard the USB host enable signal is connected to
LEDA (PWMA) of twl4030... It is an enable signal. Seriously. So what we do
here is either configure the PWMs as full on, or turn it off.
I'm not sure how common is this practice (PWM to drive enable signal) but if
we have more than one board out there with this type of connection we might be
better to add a 'gpio-pwm.c' driver to handle them.
Either way this is wrong IMHO to handle the LEDA/B via the gpio-twl4030 driver.

-- 
Péter
