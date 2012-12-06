Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2LFH2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:28:09 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:42321 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2LFH2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:28:08 -0500
X-manitu-Original-Sender-IP: 79.230.44.69
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <50C04902.7010505@grandegger.com>
Date: Thu, 06 Dec 2012 08:28:02 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de
Subject: Re: [PATCH 3/6 v9] gpio: Add userland device interface to block GPIO
References: <1354653588-4018-1-git-send-email-stigge@antcom.de> <1354653588-4018-4-git-send-email-stigge@antcom.de> <50BF99F3.4060207@grandegger.com> <50BFC8C9.5070504@antcom.de>
In-Reply-To: <50BFC8C9.5070504@antcom.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 11:20 PM, Roland Stigge wrote:
> Hi Wolfgang,
> 
> On 05/12/12 20:01, Wolfgang Grandegger wrote:
>>> +	for (i = 0; i < block->ngpio; i++) {
>>> +		status = gpio_request(block->gpio[i], "gpioblock dev");
>>
>> You could use the name of the GPIO block.
> 
> OK.
> 
>>> +		if (status)
>>> +			goto err1;
>>> +
>>> +		irq = gpio_to_irq(block->gpio[i]);
>>> +		if (irq >= 0 &&
>>> +		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
>>> +		    !gpio_block_is_irq_duplicate(block, i)) {
>>> +			status = request_irq(irq, gpio_block_irq_handler,
>>> +					     IRQF_TRIGGER_FALLING,
>>> +					     block->name, block);
>>> +			if (status)
>>> +				goto err2;
>>> +
>>> +			block->irq_controlled = true;
>>> +		}
>>> +	}
>>
>> There is no need to request IRQs if "O_NONBLOCK" is specified.
> 
> Sure? Regarding this, I found: "The poll() function shall not be
> affected by the O_NONBLOCK flag." [1]

Ah, didn't know that.

>> I observed that the read returns once immediately (without blocking)
>> after reboot. I did not look into that yet.
> 
> Didn't happen to me. Can you tell how this can be reproduced?

I think there is an interrupt pending for some reason. It might not be
the case with your setup.

Feel free to add my:

"Tested by: Wolfgang Grandegger <wg@grandegger.com>".

Will do some more tests when time permits, especially with mixed GPIO
input and output.

Wolfgang.

