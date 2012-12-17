Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2LQO5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:57:55 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:60568 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2LQO5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:57:53 -0500
X-manitu-Original-Sender-IP: 93.104.18.146
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <50CF32E3.90305@grandegger.com>
Date: Mon, 17 Dec 2012 15:57:39 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Roland Stigge <stigge@antcom.de>, rmallon@gmail.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        daniel-gl@gmx.net, sr@denx.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, highguy@gmail.com
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de> <50CF03FB.2030100@grandegger.com> <50CF0744.7040404@grandegger.com> <20121217121026.GR14363@n2100.arm.linux.org.uk>
In-Reply-To: <20121217121026.GR14363@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 01:10 PM, Russell King - ARM Linux wrote:
> On Mon, Dec 17, 2012 at 12:51:32PM +0100, Wolfgang Grandegger wrote:
>> +static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
>> +{
>> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
>> +	void __iomem *pio = at91_gpio->regbase;
>> +	u32 set_bits = val & mask;
>> +	u32 clr_bits = ~val & mask;
>> +
>> +	/* GPIO outputs can only be set at once or cleared at once */
>> +	if (set_bits)
>> +		__raw_writel(set_bits, pio + PIO_SODR);
>> +	if (clr_bits)
>> +		__raw_writel(clr_bits, pio + PIO_CODR);
>> +}
> 
> You obviously didn't see my email...

Well, I did read you mail but it was not obvious to me how to maintain
compatibility with the existing "set" method... at a first glance.
But the synchronous data output is important and it's even simpler than
I thought. The block-set callback can directly write to ODSR because
"at91_set_gpio_output()" already has set OWER. Will give that a try
later today.

Wolfgang.

