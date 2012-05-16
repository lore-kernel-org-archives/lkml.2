Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967286Ab2EPFJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:09:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61810 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab2EPFJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:09:20 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Tue, 15 May 2012 22:09:18 -0700
Message-ID: <CAOesGMjxNs2X9F7vus5z_69wqrZuMc2mMXh1CC0415JNcojHDg@mail.gmail.com>
Subject: Pre-merge window status of the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arm@kernel.org, Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Jamie Iles <jamie@jamieiles.com>, Kevin Hilman <khilman@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Barry Song <baohua.song@csr.com>, Eric Miao <eric.y.miao@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jiandong Zheng <jdzheng@broadcom.com>,
        Colin Cross <ccross@android.com>, Shawn Guo <shawn.guo@linaro.org>,
        Roland Stigge <stigge@antcom.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Turquette, Mike" <mturquette@ti.com>,
        Lennert Buytenhek <kernel@wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of the writing of this email, we have a total of 753 non-merge change
sets queued up in arm-soc for the 3.5 merge window, which we have pulled
in through 103 separate merges from the subarchitecture maintainers.

There are a few pull requests still pending; a couple have been
requested respins to fix issues and there's open questions on a few
others.

For comparison, last merge window contained 717 non-merge commits (plus
another 126 fixes later in the cycle) from arm-soc.


With the exceptions of the above mentioned branches, practically all
requests should have been received by now. If anyone is sitting on
something they are planning to get into the merge window, let us know
as soon as possible or we will likely have to postpone it until
3.6. General rule of thumb is that changes should have landed in
linux-next by -rc6 or so, and that was over a week ago.



So, with that taken care of, let's look at some of the statistics.

For this release cycle, we've had 4 external dependencies:

* One branch from Russell's tree providing new clkdev infrastructure
* Two points on the same branch from the pinctrl tree that various SoCs
 have been building driver support on top of
* i2c driver changes for lpc32xx was brought in from the i2c tree

We are also naming Mike Turquette's common clock branch as a
dependency even though it is going to be sent upstream through
arm-soc pull requests.

Top contributors for this merge window, per patch count, are:

76     Shawn Guo
55     Paul Walmsley
42     Stephen Warren
37     Kuninori Morimoto
36     Viresh Kumar
34     Tushar Behera
32     Sascha Hauer
21     Jean-Christophe PLAGNIOL-VILLARD
20     Linus Walleij
19     Daniel Lezcano

And looking at the filesystem, most changes have been in:

$ git diff deps for-next --dirstat=1.5
   6.5% arch/arm/boot/dts/
  13.6% arch/arm/mach-imx/
   1.5% arch/arm/mach-ixp2000/include/mach/
   2.0% arch/arm/mach-ixp2000/
   2.1% arch/arm/mach-ixp23xx/
   2.0% arch/arm/mach-mmp/
   2.8% arch/arm/mach-mxs/
  10.0% arch/arm/mach-omap2/
   3.5% arch/arm/mach-spear3xx/
   6.0% arch/arm/mach-tegra/
   4.4% arch/arm/mach-ux500/
   1.6% arch/arm/plat-s5p/
  16.6% arch/arm/
   4.6% drivers/clk/spear/
   1.7% drivers/clk/
   1.9% drivers/mfd/
   8.6% drivers/pinctrl/spear/
   3.1% drivers/pinctrl/
   4.5% drivers/

The 4.1% of change in mach-ixp2000 and ixp23xx are worth pointing out,
since it's the removal of those platforms. They haven't seen active
development since 2006, and no one has expressed interest in keeping
them alive. Removing unused legacy platforms makes things easier when
it comes to platform consolidation. There might be a few more
candidates down the road, but nothing has been planned as of this
time.


Just as with last merge window, we have at mostly the same
cross-sections of topic branches. This time around we have had a few
shorter ones for specific subtopics, which is normal depending on what
the focus ends up being for some of the merge windows.

The list of arm-soc topic branches to date are:

depends/clk/next Common clock infrastructure branch from Mike Turquette
next/maintainers Updates to MAINTAINERS file
next/cleanup     General cleanup patches
next/fixes       Fixes (and a few cleanups) that were not urgent enough for 3.4
next/dt          Device tree source and support changes
next/soc         New SoC support, or soc platform development
next/pinctrl     Changes enabling the new pinctrl subsystem on platforms
next/pm          power management and clock/reset changes
next/boards      board changes
next/defconfig   defconfig updates
next/drivers     drivers or SoC driver configuration updates
next/cleanup2    cleanups having dependencies on some of the above branches
next/clock       patches moving platforms to common clock infrastructure
next/dt2         device tree updates with dependencies on above branches
next/soc2        New SoC or SoC driver support depending on above branches
next/stmp-dev    library infrastructure for stmp-style device register
layouts and patches using those
staging/cleanup  late_initcall cleanups (to be moved to a next/* branch)

Another thing that has held steady since last merge window, is that we
still have a healthy amount of cleanups going in. The ones explicitly
going into the cleanup branches account for about 1/3rd of the total
commits, but there are cleanups and refactorings going in through other
topic branches as well.


-Olof
