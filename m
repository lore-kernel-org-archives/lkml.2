Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab2FAJ5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:57:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab2FAJ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:57:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] ARM: ux500: fixes for mismerge
Date: Fri, 1 Jun 2012 09:56:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arm@kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206010956.47658.arnd@arndb.de>
X-Provags-ID: V02:K0:rkCFKm2MIfZKMuaDLveOBUxO7kP0qe0+Jo9MOvMQqZ5
 HBTqiL62COs9hamuAOfD/BY2DzvdEsTnF8N0NyeIq1czddsuO+
 1j2wFfDCoblJ+G/bbiV1+XFHpRlOqtqYzrWZNLzOnK893r380O
 uz5PAmicj92v96OFU7Gj6yNNVsNKsRhF0y99GxSXTLdtOvolTt
 cdwaDE7hybrMQK4GPtUt7a6hUWIyaFIarTF9zjKgMuf8y2C69U
 P8NzRh6N3IZEg8sL0E+8a7Zy85+dl4/xS9h8BihyCaNDYxK9jR
 e8Bnm6fGpZq7+qj3C5j9FSAEpWlcpaZMWopGHm80r8hqQaICkx
 GA+6JET7Kd2+QhMLzcvY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 76f901eb4659779ecacd0e4eba49f55442daef53:                                                                                                                                       

  Merge tag 'for-v3.5' of git://git.infradead.org/battery-2.6 (2012-05-31 12:10:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git ux500/hickup

for you to fetch changes up to 5910de9e2de453956c3a18816f4838d96ac86988:

  ARM: ux500: Enable probing of pinctrl through Device Tree (2012-06-01 02:04:53 +0200)

----------------------------------------------------------------
ARM: ux500: fixes for mismerge

The device tree conversion for arm/ux500 in 3.5 turns out to be
incomplete because of a mismerge done by Linus Walleij that
I failed to notice early enough and that Lee Jones as the original
author of those patches did not manage to fix during the -next
cycle. While we originally to get a much larger set of ux500
device tree enablement patches merged, this did not happen in time.

After some discussion at Linaro Connect conference this week,
Lee has been able to do damage control and provide a series to put
the broken platform back into usable shape for both DT and non-DT
based booting.

This series has not been part of linux-next and is based on top
of the current state of the upstream kernel rather than an -rc,
but this is the best we could manage given the earlier breakage.

----------------------------------------------------------------
Lee Jones (15):
      pinctrl-nomadik: Allow Device Tree driver probing
      ARM: ux500: New DT:ed snowball_platform_devs for one-by-one device enablement
      ARM: ux500: New DT:ed u8500_init_devices for one-by-one device enablement
      ARM: ux500: Disable SMSC911x platform code registration when DT is enabled
      ARM: ux500: Remove DB8500 PRCMU platform registration when DT is enabled
      ARM: ux500: PRCMU related configuration and layout corrections for Device Tree
      ARM: ux500: Re-enable SMSC911x platform code registration during non-DT boots
      ARM: ux500: Use correct format for dynamic IRQ assignment
      ARM: ux500: Disable platform setup of the ab8500 when DT is enabled
      ARM: ux500: Only initialise STE's UIBs on boards which support them
      ARM: ux500: Apply db8500-prcmu regulator information to db8500 Device Tree
      ARM: ux500: Allow PRCMU regulator to be probed during a DT enabled boot
      ARM: ux500: Provide regulator support for SMSC911x via Device Tree
      ARM: ux500: Add support for ab8500 regulators into the Device Tree
      ARM: ux500: Enable probing of pinctrl through Device Tree

 arch/arm/boot/dts/db8500.dtsi          |  204 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/snowball.dts         |   32 ++++++++++++++++++--------
 arch/arm/configs/u8500_defconfig       |    1 +
 arch/arm/mach-ux500/board-mop500-uib.c |    4 +---
 arch/arm/mach-ux500/board-mop500.c     |   32 ++++++++++++++++++++++----
 arch/arm/mach-ux500/board-mop500.h     |    4 ++++
 arch/arm/mach-ux500/cpu-db8500.c       |   25 ++++++++++++++++++--
 drivers/mfd/db8500-prcmu.c             |    1 +
 drivers/pinctrl/pinctrl-nomadik.c      |   20 +++++++++++++++-
 9 files changed, 301 insertions(+), 22 deletions(-)
