Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab2JGUri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 16:47:38 -0400
Received: from antcom.de ([188.40.178.216]:50382 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab2JGUrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 16:47:35 -0400
Message-ID: <5071EA58.1030406@antcom.de>
Date: Sun, 07 Oct 2012 22:47:20 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 1/2 v2] gpio: Add a block GPIO API to gpiolib
References: <1349469387-20580-1-git-send-email-stigge@antcom.de> <20121007194717.GE12801@game.jcrosoft.org>
In-Reply-To: <20121007194717.GE12801@game.jcrosoft.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 07/10/12 21:47, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> +This creates a new block of GPIOs as a list of GPIO numbers with the specified
>> +size which are accessible via the returned struct gpio_block and the accessor
>> +functions described below. Please note that you need to request the GPIOs
>> +separately via gpio_request(). An arbitrary list of globally valid GPIOs can be
>> +specified, even ranging over several gpio_chips. Actual handling of I/O
>> +operations will be done on a best effort base, i.e. simultaneous I/O only where
>> +possible by hardware and implemented in the respective GPIO driver. The number
>> +of GPIOs in one block is limited to 32 on a 32 bit system, and 64 on a 64 bit
>> +system.

> this limitation is not acceptable

I guess this depends on what you want to do.

For practical reasons, accessing GPIOs collected in a word is
reasonable, IMO. And according to the replies from Stijn and Linus,
32/64 bit words are acceptable for them.

Can you please show me in which cases you need >32 bit word access (on a
32bit machine)? Practical example? Are there any GPIO controllers where
you can actually get/set 32 lines simultaneously? Then, I'd be happy to
adjust the API. (Actually, I liked Stijn's approach, which should be
reflected in my patch.)

If simultaneousness is not necessary, you can define further blocks with
32 lines each. Since your 32 bit machine will probably do only 32 bits
maximum at once, I can't see a big limit here.

Thanks for considering,

Roland
