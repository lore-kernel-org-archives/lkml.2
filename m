Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2JPRLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:11:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56053 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2JPRLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:11:12 -0400
MIME-Version: 1.0
In-Reply-To: <201210161538.29571.poeschel@lemonage.de>
References: <20120925085559.GL28670@sortiz-mobl>
	<201210160851.33324.poeschel@lemonage.de>
	<CACRpkda+UufHGEekzRxG7U3CG-_nvx1d0ophqwUUWmjkvaBTmg@mail.gmail.com>
	<201210161538.29571.poeschel@lemonage.de>
Date: Tue, 16 Oct 2012 19:11:10 +0200
Message-ID: <CACRpkdauWR-ndvPA4Q5k_boh1OvYpPWMcfSkCdvRTK9wjHLo3Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 3:38 PM, Lars Poeschel <poeschel@lemonage.de> wrote:

> I had a look at regmap. This is interesting. But there is no regmap_bus
> implementation for usb. Are you pointing me in this direction ? ;-)

I was more thinking about whether it would be useful to use for this
MFD hub. So that for this MFD and it's children, you would use
regmap to:

1) Cache registers
2) Marshall the register read/writes across USB

I don't think it would be applicable for USB, as reading & writing registers
across USB is a pretty odd usecase. (IIRC using control transfers
right?)

> And it is not guaranteed, that this "address" and "value"
> are at the same position for other usb adapters. And this is getting even
> worse, if I think of reading values out of the viperboard...

I was mainly thinking about the Viperboard MFD complex.

> I would stay at the "cache" implementation I presented in the patch - this is
> too special.

You're special just like everybody else ;-)

But to be honest I haven't seen another USB device like this.
Which probably means that next week there will be dozens of them...

Yours,
Linus Walleij
