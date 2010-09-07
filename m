Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0IGTaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:30:52 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:54566 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756652Ab0IGTat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:30:49 -0400
Message-ID: <4C8692DE.1020202@bluewatersys.com>
Date: Wed, 08 Sep 2010 07:30:38 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "avictor.za@gmail.com" <avictor.za@gmail.com>
CC: David Brownell <david-b@pacbell.net>, Eric Miao <eric.y.miao@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        bn@niasdigital.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
References: <4C85BEFD.402@bluewatersys.com>	<569801.35222.qm@web180310.mail.gq1.yahoo.com> <AANLkTinq98+ryOOKx1o1o21x9VnHz3nRCHh=5Wwixn4o@mail.gmail.com>
In-Reply-To: <AANLkTinq98+ryOOKx1o1o21x9VnHz3nRCHh=5Wwixn4o@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avictor.za@gmail.com wrote:
> hi,
> 
>> NAK still.  You're trying to abuse gpio_is_valid(),
>> which I see no need to support.
>>
>> In terms of GPIO framework architecture, zero is
>> the first GPIO in all cases, and is always
>> a valid GPIO number, even if it's not
>> requestable/swritable/readable on a given board.
>>
>> Whether it's usable on a given platform depends
>> on whether a GPIO controller is registered which
>> claims numbers 0..N ... (assuming gpiolib in use).
> 
> How should the following be done in a driver then?
> 
>    if (gpio_is_valid(device->output_pin)) {
>          if (gpio_request(device->output_pin, "driverX") != 0)
>              goto error_handling;
> 
>          /* continue with gpio setup */
>     }
>     else {
>         /* there is no vcc_pin, so don't do any gpio setup */

Adding:

	 device->output_pin = -EINVAL;

Will force the gpio to be invalid here, so that subsequent uses of
gpio_is_valid will behave as expected in the case where
device->output_pin >= 0, but doesn't map to a useable gpio.

>     }
> 
>     ....
> 
>    if (gpio_is_valid(device->output_pin)) {
>        /* set value high */
>    }

~Ryan
