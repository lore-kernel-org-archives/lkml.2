Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1JQNzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:55:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43036 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1JQNzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E9BF8D9.8030301@cam.ac.uk>
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk>
	<1318333383-17663-2-git-send-email-jic23@cam.ac.uk>
	<20111013143224.GO1098@sirena.org.uk>
	<4E96F9AC.9000001@cam.ac.uk>
	<20111013204410.GA17160@sirena.org.uk>
	<4E985C60.9020308@cam.ac.uk>
	<CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
	<4E9BF8D9.8030301@cam.ac.uk>
Date: Mon, 17 Oct 2011 15:55:05 +0200
Message-ID: <CACRpkdaEUndv=-1hkKghx7BuOQFfHKONq0n86M+v=fTms3L04g@mail.gmail.com>
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
From: Linus Walleij <linus.walleij@linaro.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        zdevai@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 11:43 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:

> Thanks for this Linus. It is more or less where I was heading with one
> exception.  I was going to link whole physical devices whereas I think
> you are proposing linking individual channels.

That's for the usecases I have at hand, I don't know which is more
common: grab the entire device and pick a few channels or grab
a single channel. I was thinking the latter would be most common
for in-kernel use.

If you need some inspiring code for how to handle registration of
mapping tables etc you can look at the API I'm pushing for the
pin control subsystem:
http://marc.info/?l=linux-kernel&m=131850357826490&w=2

> For the adc channel I'm not particularly keen on insisting every device
> have a unique name for every channel.  That breaks the effort we went to
> in IIO to enforce consistent naming (for userspace interfaces) in the first
> place.  To my mind it should never be anything other than a number.

Doesn't feel like a big issue, plain numbers are fine for me.

I was more thinking along the line that in an embedded system an
on-system-in-chip GPADC sure has specific set-in-stone uses for
each channel, i.e. the pin it connects to is hardwired somewhere,
like channel 0 is "battery-voltage", pin 1 is "battery-temperature"
etc, which makes string descriptions make sense.

It doesn't make sense for an ADC card with 100 ADC:s for random
measurements, of course.

> struct adc_map {
> /* Input / output side */
>        struct device *adc_dev;
>        const char *adc_dev_name;
>        int channel_number;
> /* User side */
>        const char *channel;
>        struct device *dev;
>        const char *dev_name;
> };

OK that makes sense.

> Anyhow, I'll have a go at implementing this over the next few days.  Before I
> do that I am going to push out the proposal to move the core IIO infrastructure
> out of staging.

Good, my gut feeling is that right now it hurts the kernel more to
have IIO in staging than it could ever hurt it to have it in drivers/,
it is getting badly needed.

Yours,
Linus Walleij
