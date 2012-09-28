Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2I1Ivv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:51:51 -0400
Received: from antcom.de ([188.40.178.216]:52499 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989Ab2I1Ivs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:51:48 -0400
Message-ID: <50656522.1050900@antcom.de>
Date: Fri, 28 Sep 2012 10:51:46 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <20120928024744.GV17667@game.jcrosoft.org> <50654E57.3080201@antcom.de> <20120928075145.GW17667@game.jcrosoft.org>
In-Reply-To: <20120928075145.GW17667@game.jcrosoft.org>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 09/28/2012 09:51 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> Right - will add checking for the request state of the respective GPIOs.
>>
>> The list of GPIOs to handle is defined by the offset (specified GPIO)
>> and bitmapped list.
>>
>> If it looks more natural, I can change this to a list of ints specifying
>> GPIOs directly.
> you pass the correctly information to the gpiolib
> 
> as if you do not request the gpio the gpiolib will auto request the gpios
> so you api will be 
> int gpio_get_block(unsigned int *gpios, u8* values, size_t size);
> 
> return an error
> 
> int gpio_set_block(unsigned int *gpios, u8* set, size_t size);
> 
> so you do not care about the banks you work on the gpiolib framework will call
> each gpio_chip seperatly. If the set_block get_block is not availlable the
> gpiolib could fallback to get/set
> 
> inside of the gpiolib that you call each bank with a bitmapped list is correct
> but not in the public gpiolib API

Good idea! Talking about the public API (your above gpio_set_block()):
*gpios is a list of GPIOs, but set is still bitmapped (mapped onto the
list specified in *gpios)? To prevent confusion about what the size
argument means (number of gpios in *gpios _or_ number of bytes in the
bitmap *set) - wouldn't it be clearer to have a "bool *set" and "bool
*values" list?

>>> And how you can hope to describe this via DT
>>
>> Haven't had planned that yet. Finally, this interface should just be
>> another view on the GPIOs already requested / assigned. Or which
>> additional info do you mean?
> how do you plan to give the gpio base vai DT to the driver as via DT we just
> pass the list of GPIO to work on

Right. If I understand correctly, with the above discussed changes, this
"GPIO base" issue is gone...

Thanks for your feedback!

Roland
