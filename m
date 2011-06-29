Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1F2GTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:19:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59204 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1F2GS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinWmdWgGD9ui+WVV7DyCzy73S5AkQ@mail.gmail.com>
References: <1307695731-28018-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTinxptCJRETreCpUoV-nU2K4fuFcmQ@mail.gmail.com>
	<BANLkTimMSChGFUSnFWFHv3nNUca_Fyawaw@mail.gmail.com>
	<20110627120256.GA19531@opensource.wolfsonmicro.com>
	<BANLkTikpMdakfTU+RRsXQVnpO4-KGkOGJQ@mail.gmail.com>
	<BANLkTinWmdWgGD9ui+WVV7DyCzy73S5AkQ@mail.gmail.com>
Date: Wed, 29 Jun 2011 08:18:59 +0200
X-Google-Sender-Auth: yYqtd03QNQT6jmTaAzWgTJJB3ik
Message-ID: <BANLkTikkxkDBOgQpGr9ZGzqFeHLmWGg+GQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] RFC: gpio: driver-local pin configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Ben Nizette <bn@niasdigital.com>, Lee Jones <lee.jones@linaro.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-arm-kernel@lists.infradead.org,
        Kurt Van Dijck <kurt.van.dijck@eia.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/28 Stijn Devriendt <highguy@gmail.com>:
> On Mon, Jun 27, 2011 at 2:37 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Mon, Jun 27, 2011 at 2:02 PM, Mark Brown
>>> How about device tree usage?  I guess there we'd end up doing it by
>>> putting the configuration on the GPIO end of things rather than on the
>>> GPIO user side?
>>
>> Sorry I can't quite understand that, please elaborate!
>>
>
> I have some code doing this as well (in a very limited fashion):
>
> int of_request_gpio(..., int* remaining_flags)
> {
>  of_get_gpio_flags(of_dev, i, remaining_flags)
>  if (flags & bias_X) {
>     gpio_set_bias(gpio, ...)
>     flags &= ~bias_X
>  }
>  // interpret all generic flags here
> };
>
> So drivers need not worry about all gpio flags and special things.
> They just request the pin; what they receive is a fully configured
> pin (with the exception of unknown flags passed out via
> remaining_flags).

Sorry there is something I don't get here or there is something you
assume, maybe.

How does this kind of design account for the case where you need
to change the biasing at runtime?

Thanks,
Linus Walleij
