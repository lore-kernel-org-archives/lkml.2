Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1F2Hjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 03:39:54 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59877 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1F2Hjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 03:39:47 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikkxkDBOgQpGr9ZGzqFeHLmWGg+GQ@mail.gmail.com>
References: <1307695731-28018-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTinxptCJRETreCpUoV-nU2K4fuFcmQ@mail.gmail.com>
	<BANLkTimMSChGFUSnFWFHv3nNUca_Fyawaw@mail.gmail.com>
	<20110627120256.GA19531@opensource.wolfsonmicro.com>
	<BANLkTikpMdakfTU+RRsXQVnpO4-KGkOGJQ@mail.gmail.com>
	<BANLkTinWmdWgGD9ui+WVV7DyCzy73S5AkQ@mail.gmail.com>
	<BANLkTikkxkDBOgQpGr9ZGzqFeHLmWGg+GQ@mail.gmail.com>
Date: Wed, 29 Jun 2011 09:39:46 +0200
Message-ID: <BANLkTikxn6QQ5DF5xq7+SvKQ--F4ka0ZLg@mail.gmail.com>
Subject: Re: [PATCH 0/2] RFC: gpio: driver-local pin configuration
From: Stijn Devriendt <highguy@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
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

On Wed, Jun 29, 2011 at 8:18 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2011/6/28 Stijn Devriendt <highguy@gmail.com>:
>> On Mon, Jun 27, 2011 at 2:37 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Mon, Jun 27, 2011 at 2:02 PM, Mark Brown
>>>> How about device tree usage?  I guess there we'd end up doing it by
>>>> putting the configuration on the GPIO end of things rather than on the
>>>> GPIO user side?
>>>
>>> Sorry I can't quite understand that, please elaborate!
>>>
>>
>> I have some code doing this as well (in a very limited fashion):
>>
>> int of_request_gpio(..., int* remaining_flags)
>> {
>>  of_get_gpio_flags(of_dev, i, remaining_flags)
>>  if (flags & bias_X) {
>>     gpio_set_bias(gpio, ...)
>>     flags &= ~bias_X
>>  }
>>  // interpret all generic flags here
>> };
>>
>> So drivers need not worry about all gpio flags and special things.
>> They just request the pin; what they receive is a fully configured
>> pin (with the exception of unknown flags passed out via
>> remaining_flags).
>
> Sorry there is something I don't get here or there is something you
> assume, maybe.
>
> How does this kind of design account for the case where you need
> to change the biasing at runtime?
>
You're right, it doesn't. It only accounts for preconfiguring pins from
device-tree of platform data.

Regards,
Stijn
