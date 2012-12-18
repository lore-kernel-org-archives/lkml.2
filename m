Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2LROa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:30:27 -0500
Received: from antcom.de ([188.40.178.216]:53780 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906Ab2LROa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:30:26 -0500
Message-ID: <50D07DFF.2040102@antcom.de>
Date: Tue, 18 Dec 2012 15:30:23 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "jbe@pengutronix.de" <jbe@pengutronix.de>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "highguy@gmail.com" <highguy@gmail.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "daniel-gl@gmx.net" <daniel-gl@gmx.net>,
        "rmallon@gmail.com" <rmallon@gmail.com>, "sr@denx.de" <sr@denx.de>,
        "wg@grandegger.com" <wg@grandegger.com>
Subject: Re: [PATCH RESEND 5/6 v10] gpio: Add device tree support to block
 GPIO API
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <1355495185-24220-6-git-send-email-stigge@antcom.de> <20121217155153.GD16561@e106331-lin.cambridge.arm.com>
In-Reply-To: <20121217155153.GD16561@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 12/17/2012 04:51 PM, Mark Rutland wrote:
>> +static int __devinit gpioblock_of_probe(struct platform_device *pdev)
>> +{
>> +	struct device_node *block;
>> +	unsigned *gpios;
>> +	int ngpio;
>> +	int ret;
>> +	struct gpio_block *gb;
>> +
>> +	for_each_available_child_of_node(pdev->dev.of_node, block) {
>> +		int i;
>> +
>> +		ngpio = of_gpio_count(block);
>> +		gpios = kzalloc(ngpio * sizeof(*gpios), GFP_KERNEL);
> 
> What if the block node is malformed? ngpio might be -ENOENT or -EINVAL.

AFAICS, of_gpio_count() always returns at least 0. Both if
CONFIG_OF_GPIO is y, m or n. And called of_gpio_named_count() also
currently doesn't return error values. Further, other drivers using
of_gpio_count() don't expect or catch <0.

However, it's reasonable to guard against of_gpio_count() < 1 since
probing without provided blocks should be void.

Will change this for the next patch update together with your leakage
findings.

Thanks for reporting!

Roland
