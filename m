Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0FWTM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:12:57 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:16714 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752041Ab0FWTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:12:56 -0400
Message-ID: <4C225CB2.6090407@bluewatersys.com>
Date: Thu, 24 Jun 2010 07:12:50 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping
 gpios)
References: <728731.73469.qm@web180307.mail.gq1.yahoo.com>
In-Reply-To: <728731.73469.qm@web180307.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> 
> --- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com> wrote:
> 
>>> --- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com>
>> wrote:

>>>> 'Can sleep' for a gpio has two different meanings
>> depending
>>>> on context
>>> NO; for the GPIO itself it's only ever had one
>>> meaning, regardless of context.
>>>
>>> You're trying to conflate the GPIO and one
>>> of the contexts in which it's used.  That's
>>> the problem you seem to be struggling with.
>>>
>>> Please stop conflating/confusing
>>> those two disparate concepts...
>> I'm not. 
> 
> BUT Your "counter" example below is solid
> proof that you are:  it shows exactly the
> confusion I pointed out:  call context versus
> the GPIO itself.  There's no way I can read
> that as anything except "you are"...
> 
>  
> Your intent here seems perhaps more to
> be a troll than to address any real
> technical issues.  I don't see much
> point participating any further.
> 
> 
>  Some gpios, such as those on io expanders, may
>> sleep in their
>> implementations of the gpio_(set/get) functions.
>>
> 
> Such GPIOs have a "cansleep" attribute, in short.
> 
> 
>> Drivers, which use a gpio, may call gpio_(set/get)
>> functions for a given
>> gpio from a context where it is not safe to sleep.
> 
> And that's the call dontext
> (in this case, from a driver).

Yes.

>   QED.  You are confusing two disparate concepts.

We are saying exactly the same thing.

> 
>  In this
>> case, a gpio
>> which may sleep (ie one on an i2c io-expander) cannot be
>> used with this
>> driver. The gpio_request will succeed, but any call to
>> gpio_(set/get)_value will produce a warning.
>>
>>>> example, if a driver calls gpio_get_value(gpio)
>> from an
>>>> interupt handler
> 
> 
> (YOU introduce interrupt/IRQ handlers...)
> 
>>>> then the gpio must not be a sleeping gpio.
>>> In a threaded IRQ handler it's OK to use
>>> the get_value_cansleep() option..
>> Ugh, you are really twisting my words.
> 
> 
> You said IRQ handler, so did I.  In what csense could I
> possibly be "twisting" your words"???
> 
> 
> STOP TROLLING.

Okay, I messed up the wording an used 'interrupt handler' as an example
of a non-sleep safe context. If I had said 'atomic' or 'spinlock'
context you would probably be telling me off for missing some other
non-sleep safe contexts.

The point is that we are discussing the issue of calls which may sleep.
Even if I was not entirely clear by getting the wording wrong, you _do_
know what I am talking about. You could correct on the bits on I get
wrong instead of labeling me a troll.

If we strip my patch back to just introducing gpio_request_cansleep,
which would be used in any driver where all of the calls are
gpio_(set/get)_cansleep, and make gpio_request only allow non-sleeping
gpios then incorrect use of gpios would be caught at request time and
returned to the caller as an error.

~Ryan


