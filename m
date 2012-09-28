Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2I1HOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:14:35 -0400
Received: from antcom.de ([188.40.178.216]:53530 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab2I1HOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:14:34 -0400
Message-ID: <50654E57.3080201@antcom.de>
Date: Fri, 28 Sep 2012 09:14:31 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <20120928024744.GV17667@game.jcrosoft.org>
In-Reply-To: <20120928024744.GV17667@game.jcrosoft.org>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 09/28/2012 04:47 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> +Block GPIO (optional)
>> +---------------------
>> +
>> +The above described interface concentrates on handling single GPIOs.  However,
>> +in applications where it is critical to set several GPIOs at once, this
>> +interface doesn't work well, e.g. bit-banging protocols via GPIO lines.
>> +Consider a GPIO controller that is connected via a slow I2C line. When
>> +switching two or more GPIOs one after another, there can be considerable time
>> +between those events. This is solved by an interface called Block GPIO:
>> +
>> +void gpio_get_block(unsigned int gpio, u8* values, size_t size);
>> +void gpio_set_block(unsigned int gpio, u8* set, u8* clr, size_t size);
>> +
>> +The function gpio_get_block() detects the current state of several GPIOs at
>> +once, practically by doing only one query at the hardware level (e.g. memory
>> +mapped or via bus transfers like I2C). There are some limits to this interface:
>> +A certain gpio_chip (see below) must be specified via the gpio parameter as the
>> +first GPIO in the gpio_chip group. The Block GPIO interface only supports
>> +simultaneous handling of GPIOs in the same gpio_chip group since different
>> +gpio_chips typically map to different GPIO hardware blocks.
> so basicaly you use a gpio numberthat you do not request, that is maybe
> requested. This is broken if you want to get or set block you need to pass the
> list of GPIO you want to control not some fancy magic

Right - will add checking for the request state of the respective GPIOs.

The list of GPIOs to handle is defined by the offset (specified GPIO)
and bitmapped list.

If it looks more natural, I can change this to a list of ints specifying
GPIOs directly.

> And how you can hope to describe this via DT

Haven't had planned that yet. Finally, this interface should just be
another view on the GPIOs already requested / assigned. Or which
additional info do you mean?

Thanks for your notes!

Roland
