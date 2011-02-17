Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1BQMEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:04:16 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:44973 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542Ab1BQMEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:04:15 -0500
Message-ID: <4D5D0EAA.9030807@metafoo.de>
Date: Thu, 17 Feb 2011 13:03:54 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com> <AANLkTi=yZZgh0v+-_Cw0JudAxxTZuBWeVCEZ-dBtENPw@mail.gmail.com>
In-Reply-To: <AANLkTi=yZZgh0v+-_Cw0JudAxxTZuBWeVCEZ-dBtENPw@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 08:33 AM, Eric Miao wrote:
> On Thu, Feb 17, 2011 at 8:56 AM, Peter Tyser <ptyser@xes-inc.com> wrote:
>> Previously, gpiolib would unconditionally flag all GPIO pins as inputs,
>> regardless of their true state.  This resulted in all GPIO output pins
>> initially being incorrectly identified as "input" in the GPIO sysfs.
>>
>> Since the direction of GPIOs is not known prior to having their
>> direction set, instead set the default direction to "unknown" to prevent
>> user confusion.  A pin with an "unknown" direction can not be written or
>> read via sysfs; it must first be configured as an input or output before
>> it can be used.
>>
> 
> Hrm... that's why I don't like the original definition of gpio_request()
> which is vague on the pin configurations.
Actually it doesn't say anything at all about the current configuration at all.
Requesting a pin grants you exclusive access to that pin, if it succeeds. So it
is solely about ownership and not about configuration.
Once you own a pin you are allowed to modify its configuration, otherwise you
should never touch it. And you shouldn't make any assumptions about its
previous configuration, if you want to use it as input you should explicitly
configure it as an input pin.

> The pin configuration should be clear upon requesting, otherwise it's a
> potential issue.
How so?

> 
> Anyway, this unknown state looks to be a good mitigation to this
> underlying problem. I'm good with it.
> 

- Lars
