Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2K2Oc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:32:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2K2Oc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:32:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] ARM: ixp4xx bug fixes
Date: Thu, 29 Nov 2012 14:32:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "arm@kernel.org" <arm@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>
References: <201211291424.25711.arnd@arndb.de>
In-Reply-To: <201211291424.25711.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201211291432.24480.arnd@arndb.de>
X-Provags-ID: V02:K0:xqM4ydaHDDavE06p03XOS9PJZLmxpD3wKQjaCpLi83r
 7bRL0T2n8lBIJJE7pOIRJ0oLRYQErGMmPMSwynQWTxbJf8xg1T
 EViv7rxj8dDxbJspJEVFRk8qNAYh11pNoYyu9GLnA370g55bJx
 VONfGLaIrp1eB+tD4KYgG8KHR3qNWumix1A+7nX+PyYxDH6pe/
 tw0jqXpahnD/q5uUc7zdJmOZY1tN7hGqrN9v7wfLFK46vz068u
 f+WW8oHycpb+LKqGSKbm6kBBXtmW+omXhPTy2c9p6mG2JIs5BI
 tL97Ye+52t5Hmv/pIqnb6QSybNY9GxiiP2zBj0h2k9PSzG/qOg
 RUvRahaOg/jH8sS7JiRs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are the bug fixes originally sent as part of a longer patch series by
Krzysztof Halasa. I've already queued them up for 3.8 now, since I think it's
too much churn this late in the cycle. On the other hand they have been
in Linux-next for ages and some of them look like they fix serious problems
in ixp4xx, so if you don't mind messing up the diffstat for the post-rc7
patches, you can also decide to pick them up.

	Arnd

---
The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/ixp4xx-fixes

for you to fetch changes up to 0d2c9f0517e915ce03a04e91d3207827e0d274a8:

  IXP4xx: use __iomem for MMIO (2012-11-22 03:36:45 +0000)

----------------------------------------------------------------
ARM: ixp4xx bug fixes

These were originally prepared by Krzysztof Halasa but not submitted
in time for v3.7 due to some confusion about how ixp4xx patches should
be handled. Jason Cooper thankfully offered to help out sending the
patches upstream through arm-soc now, but given the timing, we could
as well delay them for 3.8.

----------------------------------------------------------------
Arnd Bergmann (1):
      IXP4xx: use __iomem for MMIO

Krzysztof Hałasa (9):
      IXP4xx: Fix Goramo MultiLink platform compilation.
      IXP4xx: Fix off-by-one bug in Goramo MultiLink platform.
      IXP4xx: HW pseudo-random generator is available on IXP45x/46x only.
      IXP4xx: ixp4xx_crypto driver requires Queue Manager and NPE drivers.
      IXP4xx: Remove time limit for PCI TRDY to enable use of slow devices.
      WAN: Remove redundant HDLC info printed by IXP4xx HSS driver.
      IXP4xx crypto: MOD_AES{128,192,256} already include key size.
      IXP4xx: Always ioremap() Queue Manager MMIO region at boot.
      IXP4xx: map CPU config registers within VMALLOC region.

Tim Gardner (1):
      ixp4xx: Declare MODULE_FIRMWARE usage

 arch/arm/mach-ixp4xx/common-pci.c               |    1 +
 arch/arm/mach-ixp4xx/common.c                   |   13 +++++--------
 arch/arm/mach-ixp4xx/goramo_mlr.c               |    3 ++-
 arch/arm/mach-ixp4xx/include/mach/debug-macro.S |    4 ++--
 arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h |   46 +++++++++++++++++++---------------------------
 arch/arm/mach-ixp4xx/include/mach/qmgr.h        |   12 ++++++------
 arch/arm/mach-ixp4xx/ixp4xx_npe.c               |    9 ++++++++-
 arch/arm/mach-ixp4xx/ixp4xx_qmgr.c              |   12 +-----------
 drivers/char/hw_random/Kconfig                  |    6 +++---
 drivers/char/hw_random/ixp4xx-rng.c             |    5 ++++-
 drivers/crypto/Kconfig                          |    2 +-
 drivers/crypto/ixp4xx_crypto.c                  |   12 ++++++------
 drivers/net/wan/ixp4xx_hss.c                    |    2 +-
 13 files changed, 59 insertions(+), 68 deletions(-)
