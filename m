Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab2I3KfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 06:35:06 -0400
Received: from antcom.de ([188.40.178.216]:41975 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2I3KfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:35:05 -0400
Message-ID: <5068204F.6090606@antcom.de>
Date: Sun, 30 Sep 2012 12:34:55 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <20120928024744.GV17667@game.jcrosoft.org> <50654E57.3080201@antcom.de> <20120928075145.GW17667@game.jcrosoft.org> <50656522.1050900@antcom.de> <20120928090848.GX17667@game.jcrosoft.org> <20120928102822.GY17667@game.jcrosoft.org> <50658AD0.1050501@antcom.de> <20120928160105.GA17667@game.jcrosoft.org> <5065ED4F.5070700@antcom.de> <20120929195754.GC17667@game.jcrosoft.org>
In-Reply-To: <20120929195754.GC17667@game.jcrosoft.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/12 21:57, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> Problem here is that it's only an intermediate format since hardware
>> often needs special preparation of the data.
>>
>> But will evaluate what makes most sense.
> the key point here is to avoid to manipualte data each time we call
> gpio_block_set
> 
> hardware specific will have to be handle at driver level

Understand, thanks! I'm just trying to prevent overly complex API because:

* In our discussed scheme, the driver still needs to convert the data bits
* In practice, the block gpio API is especially useful for use on single
gpio_chips (only there, a real simultaneous i/o is possible anyway)
* Wouldn't introduce this kind of optimization in lack of measurable
improvement
* The actual i/o data bits still need handling, generating a bit CPU
load anyway.

Trying to provide as simple API as possible.

Roland
