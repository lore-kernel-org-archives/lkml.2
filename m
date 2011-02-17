Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1BQNG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:06:29 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:50553 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545Ab1BQNG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:06:26 -0500
Message-ID: <4D5D1D3E.2020107@metafoo.de>
Date: Thu, 17 Feb 2011 14:06:06 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Eric Miao <eric.y.miao@gmail.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com> <AANLkTi=yZZgh0v+-_Cw0JudAxxTZuBWeVCEZ-dBtENPw@mail.gmail.com> <4D5D0EAA.9030807@metafoo.de> <201102171321.47704.alexander.stein@systec-electronic.com>
In-Reply-To: <201102171321.47704.alexander.stein@systec-electronic.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 01:21 PM, Alexander Stein wrote:
> On Thursday 17 February 2011, 13:03:54 Lars-Peter Clausen wrote:
>> On 02/17/2011 08:33 AM, Eric Miao wrote:
>>> On Thu, Feb 17, 2011 at 8:56 AM, Peter Tyser <ptyser@xes-inc.com> wrote:
>>>> Previously, gpiolib would unconditionally flag all GPIO pins as inputs,
>>>> regardless of their true state.  This resulted in all GPIO output pins
>>>> initially being incorrectly identified as "input" in the GPIO sysfs.
>>>>
>>>> Since the direction of GPIOs is not known prior to having their
>>>> direction set, instead set the default direction to "unknown" to prevent
>>>> user confusion.  A pin with an "unknown" direction can not be written or
>>>> read via sysfs; it must first be configured as an input or output before
>>>> it can be used.
>>>
>>> Hrm... that's why I don't like the original definition of gpio_request()
>>> which is vague on the pin configurations.
>>
>> Actually it doesn't say anything at all about the current configuration at
>> all. Requesting a pin grants you exclusive access to that pin, if it
>> succeeds. So it is solely about ownership and not about configuration.
> 
> Well, ownership is a bit misleading here. You must request a GPIO to change 
> its direction. But to set or get a value this isn't required.

Well, it is not enforced in the actual code, but the GPIO API is based on
convention and I would consider it a misusage of the API to call
gpio_{set,get}_value without requesting the pin and having configured its
direction prior to it.

> In general one could expect if you requested a GPIO you are the only one to 
> call any function on it. On the other hand, this may be bad in some situations 
> where you want to read a GPIO value from different places.

Sharing GPIOs in read-only mode, is indeed something that is not covered by the
GPIO API. It might be worth adding a gpio_request_shared, which would only
permit setting the direction to input. Futher gpio_request_shared calls would
be allowed but gpio_request calls would fail.

- Lars
