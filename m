Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1BNR0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:26:41 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62425 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1BNR0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:26:39 -0500
MIME-Version: 1.0
In-Reply-To: <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
 <1297698493.965.5475.camel@petert> <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 14 Feb 2011 10:26:18 -0700
X-Google-Sender-Auth: 640zstFqAdnG0cIChGHp0w-in7c
Message-ID: <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 10:08 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > If a GPIO driver implements get_direction(), it is called in
>> > gpio_request() to set the initial direction of the pin accurately.
>>
>> I see Grant was just added as a GPIO maintainer, so added him on CC.
>>
>> Anything gating getting these 3 patches being picked up?
>
> We need four states for a gpio pin direction though. A pin can be
>
> - input
> - output

There are actually multiple output modes that a specific gpio
controller could implement, but the gpio api only has a boolean
understanding of output.  I don't know if it is really worthwhile to
try and encode all the possible configurations in this API.

> - unknown (hardware lacks get functionality and it has not been set by
>  software yet)
> - alt_func (pin is in use for some other purpose)

What is the use-case for alt_func?  From the point of view of a GPIO
driver, I don't think it cares if the pin has been dedicated to
something else.  It can twiddle all it wants, but if the pin is routed
to something else then it won't have any external effects (pin mux is
often a separate logic block from the gpio controller).  Also with
GPIOs, the engineers fiddling with them *really* needs to know what
the gpios are routed to.  It is highly unlikely to have any kind of
automatic configuration of gpios; ie. if it isn't wired as a gpio,
then don't go twiddling it.

>
> (and being able to set them alt_func was proposed a while ago and I think
> wants revisiting judging by the number of platforms which use gpio, and
> in their own arch code are privately handling alt_func stuff)

Fair enough; convince me on alt_func.  What is the use case that I'm missing?

g.
