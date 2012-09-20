Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2ITT2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:28:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42486 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2ITT2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:28:21 -0400
MIME-Version: 1.0
In-Reply-To: <201209201530.40974.arnd@arndb.de>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<50559737.8000705@gmail.com>
	<CACRpkdY-Nyn73EJLvE1RsL4hgMRm6hALtnS-eKAXU7edot2V9A@mail.gmail.com>
	<201209201530.40974.arnd@arndb.de>
Date: Thu, 20 Sep 2012 21:28:20 +0200
Message-ID: <CACRpkdZYr2B83e3mBmMkO8Ai3xU_QGevfbSOSNoTvK3Lz6y6mg@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lior Amsalem <alior@marvell.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 5:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> A corner case is the one where you have different versions of the same
> IP block (e.g. the pinctrl) and the kernel cannot find out which one it
> is by looking at registers inside it or on the parent bus, but only
> by looking at other hardware (CPU core revision, or PCI device ID of
> the root complex).

So this is the case I'm thinking of. We have e.g. differens small flags
through platform data depending on cpu_is_ux* in the ux500.

Currently we modify platform data in the board files, just as we
switch some cache handling etc as we know this or that
ASIC has different sized cache.

> We have a precedent of at91 doing this, but I don't
> like it too much because that still means having to change the driver
> again if you get a new SoC with the same IP block but a different version
> register,

I don't like that either.

> To avoid that, I'd prefer using separate "compatible"
> values, at least if the hardware is already described in separate .dtsi
> files.

So what I'm after is whether in this case statically encoding this
onto the .dtsi files is the right thing to do, or whether the boot loader
or kernel should runtime-modify the device tree, patching in
the ASIC-specific info, just like device tree files can override
properties from include files.

Or if this is a bad idea.

Nobody is doing that right now AFAICT, but it is surely possible....

Yours,
Linus Walleij
