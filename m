Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2I1Lcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:32:35 -0400
Received: from antcom.de ([188.40.178.216]:44440 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923Ab2I1Lce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:32:34 -0400
Message-ID: <50658AD0.1050501@antcom.de>
Date: Fri, 28 Sep 2012 13:32:32 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <20120928024744.GV17667@game.jcrosoft.org> <50654E57.3080201@antcom.de> <20120928075145.GW17667@game.jcrosoft.org> <50656522.1050900@antcom.de> <20120928090848.GX17667@game.jcrosoft.org> <20120928102822.GY17667@game.jcrosoft.org>
In-Reply-To: <20120928102822.GY17667@game.jcrosoft.org>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 12:28 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> gpio0 = {1};
>> set0 = {1};
>>
>> gpio1 = {33, 34};
> here should be
> 
> pin0 = {1};
> set0 = {1};
> 
> pin1 = {1, 2, 23};
> set1 = {0, 0, 1};
> 
> set_blocks(gpio_chip0, pin0, set0, 1);
> set_blocks(gpio_chip1, pin1, set1, 3);
> 
> You may need to add a prepare to do not do the conversion between array and
> gpio_chip array as I guess you will work on gpio block with multiple time
> acces

Maybe like this, for some struct block *?

block = set_block_prepare(gc, pins, values, size);
if (block) {
	set_block(gc, block);
	...
	set_block_unprepare(gc, block);
}

Would mean that all supported drivers would need to implement those 3
new functions... Need to be careful about not introducing bloat...

Thanks,

Roland
