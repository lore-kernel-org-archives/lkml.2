Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1LGOQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:16:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65323 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab1LGOQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <20111203214924.GA21511@sirena.org.uk>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
	<20111203214924.GA21511@sirena.org.uk>
Date: Wed, 7 Dec 2011 15:16:06 +0100
Message-ID: <CACRpkdZBX6ct7GNz_5AEfqgnhS75OW9n+CFTzOXMYF8hV1fwOw@mail.gmail.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 3, 2011 at 10:49 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Fri, Dec 02, 2011 at 02:56:22PM +0100, Linus Walleij wrote:
>
>> +What:                /sys/class/leds/<led>/led_current
>> +Date:                December 2011
>> +KernelVersion:       3.3
>> +Contact:     Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
>> +Description:
>> +             Read and set the current limit for the LED. Value in
>> +             milliampere.
>
> This sounds like a platform data thing - normally if you get a current
> limit wrong you're heading for magic smoke so it's not something you
> want to be playing with at runtime from userspace.

There is a platform thing, it sets the upper limit for the
current:

+/**
+ * struct ab5500_led
+ * @id: hvled index
+ * @max_current: max current permitted for hvled instance
+ * @brt_val: brightness value set for hvled
+ * @fade_hi: fadeout time high bits
+ * @fade_lo: fadeout time low bits
+ * @led_on: led is on
+ * @led_cdev: hvled class device
+ * @led_work: work to set the brightness of hvled
+ */
+struct ab5500_led {
+       u8 id;
+       u8 max_current;
+       u16 brt_val;
+       u16 fade_hi;
+       u16 fade_lo;
+       bool led_on;
+       struct led_classdev led_cdev;
+       struct work_struct led_work;
+};

Here max_current is the max current allowed by the platform.

Then in the sysfs interface:

+       if (led_curr > led->max_current)
+               led_curr = led->max_current;

You are only allowed to set a lower value than the max value.

Yours,
Linus Walleij
