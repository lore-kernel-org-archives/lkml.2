Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2LTJXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:23:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34369 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2LTJXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:23:44 -0500
Message-ID: <50D2D91B.8010203@ti.com>
Date: Thu, 20 Dec 2012 10:23:39 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] gpio: twl4030: TODO comment to remove the PWMA/B
 (LEDA/B) handling
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com> <1354791127-20545-4-git-send-email-peter.ujfalusi@ti.com> <20121219170737.E5DB13E0C56@localhost>
In-Reply-To: <20121219170737.E5DB13E0C56@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 06:07 PM, Grant Likely wrote:
> On Thu, 6 Dec 2012 11:52:07 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> This GPIO driver should not configure anything else then GPIOs.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> I'm not sure if this is the right direction. I actually have no problem
> with a single driver that registers itself with multiple interfaces (ie.
> GPIO and PWM) if it makes sense for it to do so. I suspec that a lot of
> the multifunction device drivers break things up more than is strictly
> necessary.

We have PWM drivers for these IPs. As you remember this is the reason I
started to work on the gpio-pwm driver so we can have cleaner, more generic
way to map a PWM as a gpio. I really don't like the idea of having the same
PWM code sitting in various places in the kernel just because it was easier to
hack it like that rather then to make an effort for a clean implementation.
The PWM handling in the gpio-twl4030 driver is a prime example of this IMHO.
It is just a shortcut, nothing else.

> I'll still apply this if you think it is the right direction, but I
> wanted to throw that though out there for consideration.

-- 
Péter
