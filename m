Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab2I1Sc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:32:56 -0400
Received: from antcom.de ([188.40.178.216]:40711 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758463Ab2I1Scz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:32:55 -0400
Message-ID: <5065ED4F.5070700@antcom.de>
Date: Fri, 28 Sep 2012 20:32:47 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <20120928024744.GV17667@game.jcrosoft.org> <50654E57.3080201@antcom.de> <20120928075145.GW17667@game.jcrosoft.org> <50656522.1050900@antcom.de> <20120928090848.GX17667@game.jcrosoft.org> <20120928102822.GY17667@game.jcrosoft.org> <50658AD0.1050501@antcom.de> <20120928160105.GA17667@game.jcrosoft.org>
In-Reply-To: <20120928160105.GA17667@game.jcrosoft.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 28/09/12 18:01, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> Maybe like this, for some struct block *?
>>
>> block = set_block_prepare(gc, pins, values, size);
>> if (block) {
>> 	set_block(gc, block);
>> 	...
>> 	set_block_unprepare(gc, block);
>> }
>>
>> Would mean that all supported drivers would need to implement those 3
>> new functions... Need to be careful about not introducing bloat...
> the prepare is gpiolib specific, it will be a helper to conver a gpio list to
> a gpio block list
>
> I was thinking more
>
> block = gpio_block_prepare(pins, size);
>
> gpio_block_set_value(pin0, val);
> gpio_block_set_value(pin1, val);
> gpio_block_set_value(pin2, val);
> gpio_block_set(block);
>
> andfor get
>
> gpio_block_get(block)
> val = gpio_block_get_value(block, pin0);
> val = gpio_block_get_value(block, pin1);
>
> for the gpio driver ti's transparent

Problem here is that it's only an intermediate format since hardware 
often needs special preparation of the data.

But will evaluate what makes most sense.

Thanks for your notes!

Roland
