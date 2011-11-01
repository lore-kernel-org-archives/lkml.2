Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1KBCXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:23:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1KBCW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:22:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 3/13] arm-soc driver
Date: Tue, 1 Nov 2011 04:15:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111010415.54780.arnd@arndb.de>
X-Provags-ID: V02:K0:H3OEslM+UweghwdD1dWluWqvmGi2ppRYK+Wm1fgNBTR
 5KngO27a+qlqA8gyZBH6TZHxcj8scp2GOv1J1mQUpGMA7yjyn6
 RTFyZidHbp7h3HVvX1yUiR5pIqBNe0uPZqNrjDjz1nyz2eUwm+
 uN88NKMhT5kTH+7R3eGAb86hanv4VrSotDApbhHKDLpV7f59e8
 oJ0F/KbUkWgAQgMM/FvVxyN/RT8Pq5VnimNFOzbnbEQbwJstXz
 kH1cFByHZ3RGNaRNR311aAWnYO9k8prIFJM8s2vGKC5odIqk4s
 qJSSCrpK4m0jAwTu5xBQOVVP+zxqxoaG4M4tiUoe/zHOvdu8L/
 N3h4Yx0AWqoA9Qv3R93I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small updates for imx and at91 related to device driver patches that went into
the tree elsewhere. This kind of patch should become unnecessary in the future
as we are moving the respective contents into device tree source files, but right
now it's still required for the majority of the platforms.

	Arnd

The following changes since commit e3cdb1447ad3d7ea425d5cb5b21a39c5f76e263d:

  Merge branch 'next/cleanup' into for-next (2011-11-01 00:37:00 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git ..BRANCH.NOT.VERIFIED..

Arnaud Patard (4):
      imx51: add pata device
      imx51: add pata clock
      imx: efika: Enable pata.
      Fix pata imx resource

Arnd Bergmann (2):
      Merge branches 'imx/pata' and 'imx/sata' into next/driver
      Merge branch 'at91/trng' into next/driver

Fabio Estevam (3):
      ARM: imx: Add PATA resources for other i.MX processors
      ARM: imx: Add PATA clock support
      ARM: imx: Define functions for registering PATA

Peter Korsgaard (2):
      ARM: at91: at91sam9g45: add trng clock and platform device
      hw_random: add driver for atmel true hardware random number generator

Richard Zhu (4):
      AHCI Add the AHCI SATA feature on the MX53 platforms
      MX53 Enable the AHCI SATA on MX53 ARD board
      MX53 Enable the AHCI SATA on MX53 LOCO board
      MX53 Enable the AHCI SATA on MX53 SMD board

 arch/arm/mach-at91/at91sam9g45.c                |    7 +
 arch/arm/mach-at91/at91sam9g45_devices.c        |   29 ++++
 arch/arm/mach-imx/clock-imx27.c                 |    4 +-
 arch/arm/mach-imx/clock-imx31.c                 |    4 +-
 arch/arm/mach-imx/clock-imx35.c                 |    4 +-
 arch/arm/mach-imx/devices-imx27.h               |    4 +
 arch/arm/mach-imx/devices-imx31.h               |    4 +
 arch/arm/mach-imx/devices-imx35.h               |    4 +
 arch/arm/mach-mx5/Kconfig                       |    1 +
 arch/arm/mach-mx5/board-mx53_ard.c              |    1 +
 arch/arm/mach-mx5/board-mx53_loco.c             |    1 +
 arch/arm/mach-mx5/board-mx53_smd.c              |   16 +++
 arch/arm/mach-mx5/clock-mx51-mx53.c             |   25 ++++
 arch/arm/mach-mx5/devices-imx51.h               |    4 +
 arch/arm/mach-mx5/devices-imx53.h               |    5 +
 arch/arm/mach-mx5/mx51_efika.c                  |    2 +
 arch/arm/plat-mxc/devices/Kconfig               |    7 +
 arch/arm/plat-mxc/devices/Makefile              |    2 +
 arch/arm/plat-mxc/devices/platform-ahci-imx.c   |  156 ++++++++++++++++++++++
 arch/arm/plat-mxc/devices/platform-pata_imx.c   |   59 +++++++++
 arch/arm/plat-mxc/include/mach/devices-common.h |   18 +++
 arch/arm/plat-mxc/include/mach/mx35.h           |    2 +-
 drivers/char/hw_random/Kconfig                  |   13 ++
 drivers/char/hw_random/Makefile                 |    1 +
 drivers/char/hw_random/atmel-rng.c              |  158 +++++++++++++++++++++++
 25 files changed, 524 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/plat-mxc/devices/platform-ahci-imx.c
 create mode 100644 arch/arm/plat-mxc/devices/platform-pata_imx.c
 create mode 100644 drivers/char/hw_random/atmel-rng.c

