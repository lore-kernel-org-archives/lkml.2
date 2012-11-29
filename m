Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2K2MAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:00:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45622 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2K2MAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:00:06 -0500
Date: Thu, 29 Nov 2012 12:00:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 3/3] Input: bu21013_ts - Add support for Device Tree
 booting
Message-ID: <20121129120000.GJ2013@gmail.com>
References: <1354021990-16978-1-git-send-email-lee.jones@linaro.org>
 <1354021990-16978-4-git-send-email-lee.jones@linaro.org>
 <20121128070332.GC23378@core.coreip.homeip.net>
 <20121128085731.GH2013@gmail.com>
 <20121128163105.GA28698@sirena.org.uk>
 <20121129100808.GW2013@gmail.com>
 <20121129112058.GH32691@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121129112058.GH32691@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012, Mark Brown wrote:

> On Thu, Nov 29, 2012 at 10:08:08AM +0000, Lee Jones wrote:
> > On Wed, 28 Nov 2012, Mark Brown wrote:
> 
> > > The I2C subsystem guesses at a compatible string by default but it's
> > > much better to explicitly set one as conflicts do arise from time to
> > > time (eg, Wolfson parts are called WMxxxx but the WM prefix is also used
> > > by at least WonderMedia).
> 
> > It uses the exact device name, rather than guessing. I don't think
> > you're allowed to have duplicate device names in the system, or there
> > would be clashes at registration time.
> 
> > The system is the same for platform data and DT alike.
> 
> Right, which is why this mostly works, but it's still better to provide
> an actual compatible string which we can be 100% certain will avoid
> conflicts.  This is very low cost when one is already defining DT
> bindings.

I know that it's an easy thing to do, but I'm more worried about
what would happen if the an I2C device is registered using the
current way (stripping the compatible string and using it as a
client look-up) and we also provide a compatible entry in the
driver itself. Do you know if there is any danger of duplicate
registration or suchlike?

> > Hence, there should be no need to have a compatible string in any i2c
> > driver registration information.
> 
> We're getting away with it at present (and frankly nobody's going to
> build in two different drivers for a chip of the same name for practical
> systems anyway).

Right. In the same way as we're getting away with it when we
register a platform_device using the register/add routines.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
