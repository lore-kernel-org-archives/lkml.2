Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1ECRsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:48:47 -0400
Received: from londo.lunn.ch ([80.238.139.98]:39573 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1ECRsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:48:46 -0400
X-Greylist: delayed 1289 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 13:48:46 EDT
Date: Tue, 3 May 2011 19:27:12 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110503172712.GE6538@lunn.ch>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 09:16:08PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This patchset creates a pinmux subsystem and switches U300 to use that new
> subsystem as an example. The problem is not that fantastically hard to
> solve in a general way, nobody got around to it because it requires some
> upfront code I believe, and this is my stab at it.

Hi Linus

I have some questions about how you see the following situations been
solved.

Say i have a UART core. I can be used as a 3-wire serial port, or
additionally it can have hardware flow control, or additionally it can
have all the modem signals. What would i expect to find in the pinmux
driver?

I can think of two different solutions: 

1) Three functions: uart-3wire, uart-hw-flow, uart-hw-flow-modem.  The
   first just has 2 pins, the second 4 and the last 8. The board code
   selects one of these for the serial driver to use.

2) Three functions: uart-core, uart-hw-flow, uart-mode.  The first has
   2 pins, the second has 2 pins and the last 4 pins. The board code tells
   the driver to use uart-core, plus say uart-hw-flow.

Do you think the documentation should have guidelines how best to do
this sort of core + additional optional extras?

Say i have a SoC with an SPI core. This core has the usual MISC, MOSI
and SCLK. It additionally has 4 chip select lines. My board uses chip
select lines 2 and 3 for SPI, and select lines 0 and 1 as GPIO lines.
How does the pinmux driver handle this? Again, it is the problems of a
few core pins plus additional optional extras.

Maybe the documentation should make some recommendations about what is
placed into the drivers/pinmux/pinmux-foo.c and what should be kept in
the board specific code? Without these guidelines, it seems to me,
each board for a given SoC is going to add its own peculiar pin
combination to the drivers/pinmux/pinmux-foo.c file.  Maybe it makes
more sense to have a collection of standard pin functions in
drivers/pinmux/pinmux-foo.c, which cover 75% of the likely
combinations. And recommend a board file to have its own additional
list of strange pin functions which it registers with the pinmux core?

     Thanks
        Andrew
