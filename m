Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1JATXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:23:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab1JATXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:23:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/11] Generic ARM fixes for randconfig
Date: Sat,  1 Oct 2011 21:21:49 +0200
Message-Id: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
X-Provags-ID: V02:K0:PJFia5hBfZ6RuWQ6sbSKVFyVQvabX2nyUNfO1pI3AaQ
 Sxq8ZW3ijteRDbqdELP0vzEEo/0y0+vllCnr4wmXVbous4o1tI
 wW4ngefR3v6qyhRuspJORipLgOaCYk7Std7ZzTg3/i3jiDWR21
 XXF/ugwrzcsZ1dx9EWhe5OUaqJQ4XcvgBA5ViROzesPJ+lpIVY
 nsvkf95CQVQj34U/VurMVfNh4inj+qxaBfIlzwSpHpEnIIXr2v
 7H5NyI54IjDv2wzI0cMWKKOfGGX8MZF8mNvs1Gox6je7SCYoyQ
 aw5AlGf0YaXkat9Q5r4JQ8+amdqNhjcVmHzM3EiXjBMdWRGf/R
 bRFzt3DurF+n9Ce/cNJbrMtc6TdGP8NSgu5Wzujo0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

This is a set of patches that I've been sitting on for a while
without ever getting them ready for inclusion. Out of the total
~150 patches I have to make 'make randconfig' work for a
number of ARM platforms, these are the ones that mostly for
common code within the ARM architecture.

I've now started going through the whole set and split them up
by topic so I can reduce the number of patches that are required.

Please pull these into your tree, or alternatively cherry-pick the
ones that you are happy with if you disagree with some of them.

This branch is available from

 git pull git://git.linaro.org/people/arnd/arm-soc.git randconfig/arm

For reference, I have another branch "for-next+randconfig" that
contains my entire set of patches merged with the arm-soc for-next
branch, and the individual branches are available at
git://git.linaro.org/people/arnd/linux.git

Arnd Bergmann (11):
  ARM: export rtc_lock for nvram driver
  ARM: SMP depends on MMU
  ARM: always use ARM_UNWIND for thumb2 kernels
  ARM: allow building alignment.c without PROC_FS
  ARM: vfp: use -mfloat-abi=soft to build vfp
  ARM: pm: let platforms select cpu_suspend support
  ARM: limit CONFIG_HAVE_IDE to platforms that do
  ARM: add io{read,write}{16,32}be functions
  ARM: pci: always export pcibios_bus_to_resource
  ARM: OC_ETM should not select ARM_AMBA
  ARM: common/vic: use proper __iomem annotations

 arch/arm/Kconfig              |   12 +++++++++++-
 arch/arm/Kconfig.debug        |    2 +-
 arch/arm/common/vic.c         |    3 ++-
 arch/arm/include/asm/io.h     |    6 ++++++
 arch/arm/kernel/Makefile      |    2 +-
 arch/arm/kernel/bios32.c      |    9 ++++-----
 arch/arm/kernel/time.c        |    6 ++----
 arch/arm/mach-exynos4/Kconfig |    1 +
 arch/arm/mach-omap2/Kconfig   |    2 ++
 arch/arm/mm/alignment.c       |   20 ++++++++++----------
 arch/arm/mm/proc-v7.S         |    2 +-
 arch/arm/plat-omap/Kconfig    |    1 +
 arch/arm/vfp/Makefile         |    2 +-
 lib/Kconfig.debug             |    4 ++--
 14 files changed, 45 insertions(+), 27 deletions(-)

-- 
1.7.5.4

