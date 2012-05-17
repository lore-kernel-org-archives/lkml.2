Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831Ab2EQB4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 21:56:52 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22343 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760782Ab2EQB4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 21:56:51 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 17 May 2012 10:16:15 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <swarren@wwwdotorg.org>
Subject: Re: [PATCH RFC 1/1] pinctrl: improve gpio support for dt
Message-ID: <20120517021614.GG3764@S2100-06.ap.freescale.net>
References: <1337090839-21224-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1337090839-21224-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 10:07:19PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> For dt, the gpio base may be dynamically allocated, thus the original
> implementation of gpio support based on static gpio number and pin id
> map may not be easy to use for dt.
> 
> One solution is a) use alias id for gpio node and refer to it in gpio
> range, then we can get the fixed the gpio devices for this range and
> b) get gpio chip from node which is specified in gpio range structure,
> then get the dynamically allocated gpio chip base and c) using the chip
> gpio base and offset to map to a physical pin id for dt.
> 
> To implement that, we need add two members in pinctrl_gpio_range structure,
> 'np' the gpio node for this range and 'off' the offset in this gpio range
> of the gpio chip.
> 
> For devicetree, user can use this two member instead of range->base
> to create the map, the core will dynamically set the correct range->base
> based on the gpio base plus gpio offset.
> 
> For example:
> static struct pinctrl_gpio_range imx28_gpio_ranges[] = {
> 	{ .name = "gpio", .id = 0, .pin_base = 0,   .npins = 8,	 .np = np_gpio0	.off = 0,},
> 	{ .name = "gpio", .id = 0, .pin_base = 16,  .npins = 13, .np = np_gpio0 .off = 16,},
> 	{ .name = "gpio", .id = 1, .pin_base = 32,  .npins = 32, .np = np_gpio1 .off = 16},

How do you have .np statically assigned?

-- 
Regards,
Shawn

