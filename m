Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab2EDTeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:34:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63897 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2EDTeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:34:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: Handling of modular boards
Date: Fri, 4 May 2012 19:34:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
In-Reply-To: <20120504185850.GO14230@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041934.08830.arnd@arndb.de>
X-Provags-ID: V02:K0:udWoBleikcwWNuT+Eovdp1VU8pspMwL9eXfWZ0j/lvP
 tf1FR2DdmcJm5Xumzg2wSE1ge+ercdbXQh2y8kMWYhYBIP9qp7
 nB/kQiq9ZT4K+F0hXuUFEpSfVT6Nw9avNR6gxMlKpb5gyogkKR
 ia0M13F65hF/bwyT+jfgaVjh36WFbijhaHRxipLF/WQCUAgfrc
 QG+4peeTQb+8bT593lghDJ/I2gIMt3vGfJNEmJoR9DilX51NO1
 PWYrZ99myofjluGwpN0kiV6tG5b3xQWWBDDMFWpxy1bQuiUTp/
 QFBOajgrj/YkpK9iJ20vrb88hbQKTx5mmY5fLq9cUNW9dySrpr
 1BgNSPvFgPq1LAA4P6Ys=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Mark Brown wrote:
> Quite a few reference platforms (including Wolfson ones, which is why
> I'm particularly interested) use replaceable modules to allow
> configuration changes.  Since we can often identify the configuration at
> runtime we should ideally do that but currently there's no infrastructure 
> to help with that, generally this seems to be done in arch code for the
> machine but this doesn't scale when even the CPU might change and isn't
> terribly device tree compatible either.
> 
> For reference the code for current Wolfson plugin modules is in
> arch/arm/mach-s3c64xx/mach-crag6410-module.c.

Hi Mark,

Thanks for getting the discussion started. I've seen the same issue come
up for arch/arm/mach-ux500/board-mop500*uib.c and for the beaglebone.
I'm sure there are many more, but we should make sure that everyone
of these can live with whatever we come up with.

> The most obvious current fit here is the MFD subsystem but it feels like
> we need some slightly different infastructure to what MFD currently
> provides.  MFD is really set up to handle platform devices with a core
> and linear ranges of resources fanning out from that core since they're
> really oriented around chips.  In contrast these boards are more about
> remapping random collections of potentially unrelated resources and
> instantiating devices on all sorts of buses and share more with board
> files.
> 
> I'm just starting to put some stuff together for this so I was wondering
> if anyone had been thinking about this and had any bright ideas for how
> to handle it, and also if people think that MFD is a good fit for this
> or if we should split the silicon MFDs from these PCBs.

One idea that I've heard before is to put device tree fragments into the
kernel and dynamically add them to the device tree that was passed by the
boot loader whenever we detect the presence of a specific device.
This obviously means it works only for boards using DT for booting, but
it allows us to use some infrastructure that we already have.

Another idea was to put all the possible extensions into the device tree
for a given board and disable them by default, putting it into the
responsibility of the boot loader to enable the one that is actually
being used. This has serious scalibility problems when there are many
possible extensions and also relies more on the boot loader than I would
like.

An intermediate solution that I really like is the ability to
stuff device tree fragments on extension board themselves, but that
can only work for new designs and causes problems when that information
is not actually correct.

	Arnd
