Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2DEWWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:22:17 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:65107 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336Ab2DEWWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:22:14 -0400
Date: Fri, 6 Apr 2012 00:21:54 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH 0/1] Renaming AMBA to PRIMECELL
Message-ID: <cover.1333663714.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only patch in this series renames CONFIG_ARM_AMBA to
CONFIG_ARM_PRIMECELL in Kconfig and the only source file with
#ifdef.

I compile-tested on the following defconfigs: "integrator realview
versatile vexpress bcmring ep93xx lpc32xx u300 u8500 nhk8815 spear3xx
spear6xx", diffing the stderr of the two compilations.

While this patch is self-contained and works, there are other
open points. I think only 4- below is worth doing, but I need
confirmation before doing that.

1- drivers/of/platform.c still has "amba" in its names. Worse, it has
"amba-bus" in its device tree compatibility list (and some drivers
have it too). I think this should stay.

2- Actually, grepping for "amba" or "AMBA" finds a lot of related
code. Some uses are correct and some are not.  I don't think an
audit here is worth the effort; users will adapt over time, only
where it makes sense and only when otherwise touching the code.

3- Should drivers/amba/bus.c  be renamed to drivers/primecell/bus.c
or drivers/amba/primecell.c (I think the former but I'm not sure
it's the bext name anyways)

4- Should linux/amba/bus.h be renamed to linux/primecell/bus.h or
linux/amba/primecell.h? (I think the former, leaving the old
name around for a while, so out-of-tree drivers are happy
and #warn'ed about the change.

/alessandro



Alessandro Rubini (1):
  ARM: Rename CONFIG_ARM_AMBA to CONFIG_ARM_PRIMECELL

 arch/arm/Kconfig                  |   36 ++++++++++++++++++++++--------------
 arch/arm/Kconfig.debug            |    2 +-
 arch/arm/mach-exynos/Kconfig      |    4 ++--
 arch/arm/mach-mxs/devices/Kconfig |    2 +-
 arch/arm/mach-netx/Kconfig        |    4 ++--
 arch/arm/mach-omap2/Kconfig       |    2 +-
 arch/arm/plat-samsung/Kconfig     |    2 +-
 drivers/Makefile                  |    2 +-
 drivers/dma/Kconfig               |    4 ++--
 drivers/gpio/Kconfig              |    2 +-
 drivers/input/serio/Kconfig       |    2 +-
 drivers/mmc/host/Kconfig          |    2 +-
 drivers/of/platform.c             |   10 +++++-----
 drivers/rtc/Kconfig               |    4 ++--
 drivers/spi/Kconfig               |    2 +-
 drivers/tty/serial/Kconfig        |    4 ++--
 drivers/video/Kconfig             |    2 +-
 drivers/watchdog/Kconfig          |    2 +-
 sound/arm/Kconfig                 |    2 +-
 19 files changed, 49 insertions(+), 41 deletions(-)

-- 
1.7.7.2
