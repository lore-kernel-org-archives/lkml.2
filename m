Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2ITTgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:36:49 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:34033 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2ITTgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:36:48 -0400
Date: Thu, 20 Sep 2012 21:36:36 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lior Amsalem <alior@marvell.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
Message-ID: <20120920213636.2ee27d41@skate>
In-Reply-To: <CACRpkdZYr2B83e3mBmMkO8Ai3xU_QGevfbSOSNoTvK3Lz6y6mg@mail.gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<50559737.8000705@gmail.com>
	<CACRpkdY-Nyn73EJLvE1RsL4hgMRm6hALtnS-eKAXU7edot2V9A@mail.gmail.com>
	<201209201530.40974.arnd@arndb.de>
	<CACRpkdZYr2B83e3mBmMkO8Ai3xU_QGevfbSOSNoTvK3Lz6y6mg@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus Walleij,

On Thu, 20 Sep 2012 21:28:20 +0200, Linus Walleij wrote:

> So what I'm after is whether in this case statically encoding this
> onto the .dtsi files is the right thing to do, or whether the boot loader
> or kernel should runtime-modify the device tree, patching in
> the ASIC-specific info, just like device tree files can override
> properties from include files.
> 
> Or if this is a bad idea.
> 
> Nobody is doing that right now AFAICT, but it is surely possible....

If I understand correctly, we would like drivers to be able to read
some common "system" registers to figure out which SoC variant we are
running on. Such feature should normally be provided by code in
arch/arm/mach-*/ and called by drivers, but we are trying to eliminate
all dependencies of driver code on architecture code, correct?

So, wouldn't we need a small, architecture-independent, infrastructure,
through which architecture-specific code could "register" at boot
time which SoC we are running on, and drivers could query this
information from the common infrastructure?

Of course, the major problem is to figure out what is the good
representation for this SoC identifier. Do we need a big list of SoCs
like we had machine IDs? A simple string? Or maybe there is just no
good way, and the whole idea is moot.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
