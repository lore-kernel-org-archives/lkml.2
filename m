Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2LEWWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:22:21 -0500
Received: from antcom.de ([188.40.178.216]:42827 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab2LEWWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:22:19 -0500
Message-ID: <50BFC8C9.5070504@antcom.de>
Date: Wed, 05 Dec 2012 23:20:57 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de
Subject: Re: [PATCH 3/6 v9] gpio: Add userland device interface to block GPIO
References: <1354653588-4018-1-git-send-email-stigge@antcom.de> <1354653588-4018-4-git-send-email-stigge@antcom.de> <50BF99F3.4060207@grandegger.com>
In-Reply-To: <50BF99F3.4060207@grandegger.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

On 05/12/12 20:01, Wolfgang Grandegger wrote:
>> +	for (i = 0; i < block->ngpio; i++) {
>> +		status = gpio_request(block->gpio[i], "gpioblock dev");
> 
> You could use the name of the GPIO block.

OK.

>> +		if (status)
>> +			goto err1;
>> +
>> +		irq = gpio_to_irq(block->gpio[i]);
>> +		if (irq >= 0 &&
>> +		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
>> +		    !gpio_block_is_irq_duplicate(block, i)) {
>> +			status = request_irq(irq, gpio_block_irq_handler,
>> +					     IRQF_TRIGGER_FALLING,
>> +					     block->name, block);
>> +			if (status)
>> +				goto err2;
>> +
>> +			block->irq_controlled = true;
>> +		}
>> +	}
> 
> There is no need to request IRQs if "O_NONBLOCK" is specified.

Sure? Regarding this, I found: "The poll() function shall not be
affected by the O_NONBLOCK flag." [1]

> I observed that the read returns once immediately (without blocking)
> after reboot. I did not look into that yet.

Didn't happen to me. Can you tell how this can be reproduced?

Thanks,

Roland


[1] http://pubs.opengroup.org/onlinepubs/009695399/functions/poll.html
