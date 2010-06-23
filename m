Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab0FWE6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 00:58:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51256 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0FWE6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 00:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=a5oY/MgH2QzyL8xyc9SZSblfyHvsViPcXd1DQAIrtFClS/+ir1U3MzI6s36BuHY8/R
         y7uqkmZ0xPNo+qZKAl+lLQhH4sTtYjeLlVH8Y5jj4j66Xyf7ZOsVODukWoUNqLUv7IWM
         Vx/Ll6mOflI13PVbLGmfcfNh6lBbc0sY7jJBc=
MIME-Version: 1.0
In-Reply-To: <191168.5104.qm@web180308.mail.gq1.yahoo.com>
References: <4C216A79.7000305@bluewatersys.com> <191168.5104.qm@web180308.mail.gq1.yahoo.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 23 Jun 2010 12:58:19 +0800
Message-ID: <AANLkTinuO053upBHzsiQ2llNdu4_XZN0rfz01QuIE7LW@mail.gmail.com>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping 
	gpios)
To: David Brownell <david-b@pacbell.net>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Ryan Mallon <ryan@bluewatersys.com>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/23 David Brownell <david-b@pacbell.net>:
>
>
> --- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com> wrote:
>
>
>> gpiolib
>
>
> Again, you're talking about "gpiolib" when
> you seem to mean the GPIO framework itself
> (for which gpiolib is only an implementation
> option)...
>
>> framework could be simplified for cansleep gpios.
>>
>> 'Can sleep' for a gpio has two different meanings depending
>> on context
>
> NO; for the GPIO itself it's only ever had one
> meaning, regardless of context.
>
> You're trying to conflate the GPIO and one
> of the contexts in which it's used.  That's
> the problem you seem to be struggling with.
>
> Please stop conflating/confusing
> those two disparate concepts...
>
> I hope you don't have such a hard time with
> the distinction in other contexts.  Like,
> the fact that some calls can't be made while
> holding spinlocks.  That notion is everywhere
> in Linux.
>
>
>> example, if a driver calls gpio_get_value(gpio) from an
>> interupt handler
>> then the gpio must not be a sleeping gpio.
>
> In a threaded IRQ handler it's OK to use
> the get_value_cansleep() option..
>
>
>
>>
>> This patch introduces a new flag, FLAG_CANSLEEP, internal
>> to gpiolib
>
> NAK; Superfluous; the gpio_chip already has
> that information recorded.
>
>
>> new request function, gpio_request_cansleep, requests a
>> gpio which may
>> only be used from sleep possible contexts
>
> Also superfluous.
>
>
>  The existing
>> gpio_request
>> function requests a gpio, but does not allow it to be used
>> from a
>> context where sleep is not possible.
>
> Changing semantics of existing calls is a big
> mess, and should be avoided even if it seems
> appropriate.
>
> Since the request is just reserving a resource
> that's already been identified (and which has
> known characteristics, like whether the GPIO
> value must be accessed only from sleeping
> contexts), this call would also be superfluous.
>
> If you want to ensure the GPIO is a cansleep()
> one, just check that before reserving it.  There
> is no need for new calls to support that model;
> it works today.
>
> (NAK...)
>
>
>
>> The benefits I see to this approach are:
>>  ...
>>  - The API is simplified by combining gpio_(set/get)_value
>> and
>> gpio_(set/get)_value_cansleep
>
>
> You have a strange definition of "simplified"...
>
> Recognize that you're also proposing to remove
> an API characteristic which much simplifies
> code review:  you can look at calls and see
> that because they're the cansleep() version,
> they are unsafe in IRQ context ...
>
> That is, you're making code (and patch)
> reviews much harder and more error-prone.
> This isn't good, and doesn't simplify any
> process I can think of...
>
> So, NAK on these proposed changes.
>

Hi David,

You are really a NAKing machine ;-) People get confused for a reason, and
I believe you have a good solution for this?
