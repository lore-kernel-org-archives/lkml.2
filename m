Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2LRQfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:35:10 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38204 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab2LRQfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:35:08 -0500
Date: Tue, 18 Dec 2012 16:35:02 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Roland Stigge <stigge@antcom.de>
Cc: "rmallon@gmail.com" <rmallon@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "daniel-gl@gmx.net" <daniel-gl@gmx.net>, "sr@denx.de" <sr@denx.de>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "highguy@gmail.com" <highguy@gmail.com>
Subject: Re: [PATCH RESEND 5/6 v10] gpio: Add device tree support to block
 GPIO API
Message-ID: <20121218163502.GB32484@e106331-lin.cambridge.arm.com>
References: <1355495185-24220-1-git-send-email-stigge@antcom.de>
 <1355495185-24220-6-git-send-email-stigge@antcom.de>
 <20121217155153.GD16561@e106331-lin.cambridge.arm.com>
 <50D07DFF.2040102@antcom.de>
MIME-Version: 1.0
In-Reply-To: <50D07DFF.2040102@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Dec 2012 16:35:03.0910 (UTC) FILETIME=[A1B13060:01CDDD3D]
X-MC-Unique: 112121816350405801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 02:30:23PM +0000, Roland Stigge wrote:
> Hi Mark,
> 
> On 12/17/2012 04:51 PM, Mark Rutland wrote:
> >> +static int __devinit gpioblock_of_probe(struct platform_device *pdev)
> >> +{
> >> +	struct device_node *block;
> >> +	unsigned *gpios;
> >> +	int ngpio;
> >> +	int ret;
> >> +	struct gpio_block *gb;
> >> +
> >> +	for_each_available_child_of_node(pdev->dev.of_node, block) {
> >> +		int i;
> >> +
> >> +		ngpio = of_gpio_count(block);
> >> +		gpios = kzalloc(ngpio * sizeof(*gpios), GFP_KERNEL);
> > 
> > What if the block node is malformed? ngpio might be -ENOENT or -EINVAL.
> 
> AFAICS, of_gpio_count() always returns at least 0. Both if
> CONFIG_OF_GPIO is y, m or n. And called of_gpio_named_count() also
> currently doesn't return error values. Further, other drivers using
> of_gpio_count() don't expect or catch <0.

Whoops. I'd managed to misread the logic in of_gpio_named_count, sorry.

> However, it's reasonable to guard against of_gpio_count() < 1 since
> probing without provided blocks should be void.
> 
> Will change this for the next patch update together with your leakage
> findings.
> 
> Thanks for reporting!
> 
> Roland

Sounds good!

Thanks,
Mark.

