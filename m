Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1BOXzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:55:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51839 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755664Ab1BOXzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:55:02 -0500
Date: Tue, 15 Feb 2011 23:55:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110215235517.GA2462@opensource.wolfsonmicro.com>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
 <1297698493.965.5475.camel@petert>
 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
 <20110214193502.101759d0@lxorguk.ukuu.org.uk>
 <1297726502.965.6921.camel@petert>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297726502.965.6921.camel@petert>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 05:35:02PM -0600, Peter Tyser wrote:

> Also, in most cases I'd think that the BIOS/U-Boot/firmware should have
> configured the GPIO pins appropriately, which Linux should inherit in
> general.  Linux currently inherits GPIO states that were set in firmware
> when a GPIO is requested, but it doesn't properly report those values
> via sysfs - that's the only bug I'm trying to fix.

That's one model for these things but it's *far* from universal.
Another model which is at least as common is that the bootloader does
the minimum possible to transfer control to Linux which then does the
actual configuration for the system.

> Are there many cases where people need to swap a pin from GPIO to alt
> functionality, and back again in Linux?  I have never seen them used
> like that; generally they are either wired up to an alt_func device (I2C
> pins, serial pins, etc), or as a GPIO - not both dynamically.  If some
> hardware does need to do that, isn't it very chipset/board specific?  I

No, it's very rare.  One example we have in the kernel is the PXA27x
AC'97 driver - the controller doesn't generate one of the resets
correctly so the driver puts the signals into GPIO mode and manually
generates the reset on the bus for the CODEC when it needs to do so.

> guess I'm just not really grasping the big advantage of the alt_func
> feature, or how it'd be implemented as common code.  It looks like there
> was a thread about it back in 2009 that didn't go anywhere:
> http://thread.gmane.org/gmane.linux.kernel/851818

I tend to agree; I strongly expect that any alternate function code
would just wind up feeding at best device specific if not system
specific constants through and give us no more generality than we have
now.
