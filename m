Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2I1JXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:23:40 -0400
Received: from antcom.de ([188.40.178.216]:59474 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab2I1JXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:23:39 -0400
Message-ID: <50656C99.50204@antcom.de>
Date: Fri, 28 Sep 2012 11:23:37 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <20120928024744.GV17667@game.jcrosoft.org> <50654E57.3080201@antcom.de> <20120928075145.GW17667@game.jcrosoft.org> <50656522.1050900@antcom.de> <20120928090848.GX17667@game.jcrosoft.org>
In-Reply-To: <20120928090848.GX17667@game.jcrosoft.org>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 11:08 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> Good idea! Talking about the public API (your above gpio_set_block()):
>> *gpios is a list of GPIOs, but set is still bitmapped (mapped onto the
>> list specified in *gpios)? To prevent confusion about what the size
>> argument means (number of gpios in *gpios _or_ number of bytes in the
>> bitmap *set) - wouldn't it be clearer to have a "bool *set" and "bool
>> *values" list?
> public API list of gpio as example
> 
> gpios = {1, 33, 34, 55};
> set = {1, 0, 0 ,1};
> 
> gpio_set_blocks(gpios, set, 4);
> 
> private you do just provide the array related to the gpio_chip
> lets assume 4 bank with 32 gpio each
> 
> gpio0 = {1};
> set0 = {1};
> 
> gpio1 = {33, 34};
> set1 = {0, 0};
> 
> gpio2 = {55};
> set2 = {1};
> 
> set_blocks(gpio_chip0, gpio0, set0, 1);
> set_blocks(gpio_chip1, gpio1, set1, 2);
> set_blocks(gpio_chip2, gpio2, set2, 1);

Good.

For the internal driver API (gpio_chip), we even don't really need the
first argument (gpio_chip) since we can infer it from the gpios.

Will provide an update.

Roland
