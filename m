Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1JQPLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:11:39 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46794 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab1JQPLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:11:38 -0400
MIME-Version: 1.0
In-Reply-To: <20111014145900.GA28728@S2100-06.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
	<20111014145900.GA28728@S2100-06.ap.freescale.net>
Date: Mon, 17 Oct 2011 17:11:36 +0200
Message-ID: <CACRpkdZ7QZJ5YwDYKHKmCz7ssPr9Au8mVk4P3R1RMbbOpe9XNQ@mail.gmail.com>
Subject: Re: pinctrl_config APIs, and other pinmux questions
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 4:59 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> [Stephen]
>> I've started to look at porting the Tegra pinmux driver to your pinctrl
>> subsystem. In order to replace the existing pinmux driver, I need a way
>> to support configuring options such as tri-state, pull-up/down, drive-
>> strength, etc.
>>
> I'm also concerned about this.  The current pinctrl subsystem only
> implements pinmux.  Before pin/pad configuration (pincfg) support is
> available, I can not really convert imx iomuxc driver (iomux-v3) over
> to use the subsystem.

I have the same problem for drivers/gpio/gpio-nomadik. which
does all weird kind of stuff. So you're not alone.

The reason why this is not in the subsystem as of today is that
we cannot push hundreds of kilobytes of upfront design with no drivers
using it, the current patch set in for-next is big enough as it is right
now.
http://en.wikipedia.org/wiki/Big_Design_Up_Front

But we can start thinking about the next step, so lets design the
generic pin control stuff we need and merge it to -next early so
we can work on it next kernel cycle.

Yours,
Linus Walleij
