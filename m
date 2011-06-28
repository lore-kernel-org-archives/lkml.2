Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab1F1LzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:55:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56709 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab1F1LxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikpMdakfTU+RRsXQVnpO4-KGkOGJQ@mail.gmail.com>
References: <1307695731-28018-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTinxptCJRETreCpUoV-nU2K4fuFcmQ@mail.gmail.com>
	<BANLkTimMSChGFUSnFWFHv3nNUca_Fyawaw@mail.gmail.com>
	<20110627120256.GA19531@opensource.wolfsonmicro.com>
	<BANLkTikpMdakfTU+RRsXQVnpO4-KGkOGJQ@mail.gmail.com>
Date: Tue, 28 Jun 2011 13:53:07 +0200
Message-ID: <BANLkTinWmdWgGD9ui+WVV7DyCzy73S5AkQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] RFC: gpio: driver-local pin configuration
From: Stijn Devriendt <highguy@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kyungmin Park <kmpark@infradead.org>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Ben Nizette <bn@niasdigital.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 2:37 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jun 27, 2011 at 2:02 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> On Mon, Jun 27, 2011 at 01:44:43PM +0200, Linus Walleij wrote:
>>
>>> Yes. To make the driver platform neutral, it needs to for example
>>> provide a callback in the platform data like (* set_pin_bias) or so,
>>> and then your platform has to implement this biasing.
>>
>>> In this specific case that kind of stuff would likely be preferable
>>> to have in the platform anyway, but I understand what you mean.
>>
>> How about device tree usage?  I guess there we'd end up doing it by
>> putting the configuration on the GPIO end of things rather than on the
>> GPIO user side?
>
> Sorry I can't quite understand that, please elaborate!
>

I have some code doing this as well (in a very limited fashion):

int of_request_gpio(..., int* remaining_flags)
{
  of_get_gpio_flags(of_dev, i, remaining_flags)
  if (flags & bias_X) {
     gpio_set_bias(gpio, ...)
     flags &= ~bias_X
  }
  // interpret all generic flags here
};

So drivers need not worry about all gpio flags and special things.
They just request the pin; what they receive is a fully configured
pin (with the exception of unknown flags passed out via
remaining_flags).

Regards,
Stijn
