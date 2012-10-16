Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2JPNij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:38:39 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:29039 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab2JPNii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:38:38 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.766
From: Lars Poeschel <poeschel@lemonage.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
Date: Tue, 16 Oct 2012 15:38:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
References: <20120925085559.GL28670@sortiz-mobl> <201210160851.33324.poeschel@lemonage.de> <CACRpkda+UufHGEekzRxG7U3CG-_nvx1d0ophqwUUWmjkvaBTmg@mail.gmail.com>
In-Reply-To: <CACRpkda+UufHGEekzRxG7U3CG-_nvx1d0ophqwUUWmjkvaBTmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210161538.29571.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012 at 12:00:13, Linus Walleij wrote:
> On Tue, Oct 16, 2012 at 8:51 AM, Lars Poeschel <poeschel@lemonage.de> wrote:
> > On Monday 15 October 2012 at 15:00:12, Linus Walleij wrote:
> >> > +       /* if io is set to output, just return the saved value */
> >> > +       if (gpio->gpioa_out & (1 << offset))
> >> > +               return gpio->gpioa_val & (1 << offset);
> >> 
> >> That's not going to work if the hardware changes state
> >> behind the back of the driver right? Oh well, maybe
> >> it doesn't matter.
> > 
> > I thought about that and then did this "cache" only in case the gpio is a
> > output to save to usb ping-pong that is needed otherwise. I thought that
> > nothing can change to state of the output but the driver itself.
> 
> On a second note there is already a standard mechanism for caching
> registers in the kernel, and that is regmap. Sadly it's a bit
> undocumented but there are several examples and the code
> lives in drivers/base/regmap and include/linux/regmap.h

I had a look at regmap. This is interesting. But there is no regmap_bus 
implementation for usb. Are you pointing me in this direction ? ;-) I don't 
think you want me as a kernel newbie write this code.
And another thing: I don't think this can be implemented in such a general way 
as it is done already for i2c or mmio. As you see in the example of my 
(viperboard-)adapter, there is a bunch bytes sent, just to set the direction 
bit in a register. And it is not guaranteed, that this "address" and "value" 
are at the same position for other usb adapters. And this is getting even 
worse, if I think of reading values out of the viperboard...
I would stay at the "cache" implementation I presented in the patch - this is 
too special.

Lars
