Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1GZXCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:02:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62114 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab1GZXCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:02:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: [GIT PULL] arm-soc new board support for 3.1
Date: Wed, 27 Jul 2011 01:01:44 +0200
Message-ID: <5818290.TCY0zMWmbr@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <2178768.MnKF3D4aeP@wuerfel>
References: <3057645.NjCAYUXHGt@wuerfel> <1687325.AEKSI6RCv5@wuerfel> <2178768.MnKF3D4aeP@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iSXlXx7Ev2LCPREAAL2raO4wKpYh3lobaMlzQcaNwQS
 KvZv+ouGAgfYv/XJQ+Duqlkyv3ARfrNS6EF4gkQgjVgABI72o0
 kiZSWQFXeX/Gi6k+NHW1LULYjLVT3ip841GNRCMcPIhKLKNcyJ
 1/vVheDurdgKoyQWZ+QcVwrpXvdsrbA2K1wFMzyb0i4xlMGKgp
 ogiLRqiy/DMVIYHbwTXfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This adds support for new boards in the TI omap and samsung s3c platforms.
These platforms are still a long way from being able to add support for
new boards just with a device tree instead of a board file, but it's
clear from the work going into these platforms that the maintainers
are actively working on changing that.

Once we get to the point that the platforms can describe a board using
a device tree, we will start removing existing board files and no longer
allow new ones. Until then, my feeling is that we need to allow additional
boards to be added when they are clean enough and work is proceeding on
obsoleting them.

	Arnd

The following changes since commit ba5b56cb3e3d2cab73d4fee9a022bb69462a8cd9:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2011-07-26 13:38:50 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ next/board

Ambresh K (1):
      OMAP4: DMTIMER: enable autoidle mode

Ameya Palande (1):
      omap: rx51: Platform support for lp5523 led chip

Arnd Bergmann (2):
      Merge branch 'omap/board' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/board
      Merge branch 'next-samsung-board' of git://git.kernel.org/.../kgene/linux-samsung into next/board

Charulatha V (1):
      omap: ZOOM: QUART: Request reset GPIO

Daniel Mack (1):
      omap: Overo: remove duplicate call to overo_ads7846_init()

Igor Grinberg (3):
      arm: omap3: cm-t35: minor comments fixes
      arm: omap3: cm-t35: fix slow path warning
      arm: omap3: cm-t35: add support for cm-t3730

Joel A Fernandes (1):
      OMAP3: beagle: add support for beagleboard xM revision C

Julia Lawall (1):
      arch/arm/mach-omap2/clock.c: add missing clk_put

Kalle Jokiniemi (1):
      OMAP3: rx-51: Add full regulator definitions

Mark Brown (5):
      ARM: S3C64XX: Initial support for Wolfson/Simtec Cragganmore/Banff
      ARM: S3C64XX: Refresh Cragganmore support
      ARM: S3C64XX: Configure supplies for all Cragganmore regulators

Ohad Ben-Cohen (2):
      omap: iovmm: s/sg_dma_len(sg)/sg->length/
      OMAP4: iommu: fix clock name

Shubhrajyoti Datta (1):
      OMAP4: Keyboard: Mux changes in the board file

Silesh C V (2):
      omap: HSMMC: Fix GPIO muxing
      omap: 4430SDP: Register the card detect GPIO properly

Suman Anna (1):
      omap: iommu: fix pte programming

Tony Lindgren (2):
      Merge branch 'iommu-for-tony' of git://github.com/ohadbc/omap-iommu into devel-fixes
      Merge branch 'cleanup-part-2' into devel-board

Vishal Mahaveer (1):
      omap: blaze: add mmc5/wl1283 device support

 arch/arm/mach-omap2/Kconfig                    |    6 +-
 arch/arm/mach-omap2/board-4430sdp.c            |  148 +++++-
 arch/arm/mach-omap2/board-cm-t35.c             |   95 ++-
 arch/arm/mach-omap2/board-omap3beagle.c        |   78 ++-
 arch/arm/mach-omap2/board-overo.c              |    1 -
 arch/arm/mach-omap2/board-rx51-peripherals.c   |  135 ++++
 arch/arm/mach-omap2/board-zoom-debugboard.c    |    9 +
 arch/arm/mach-omap2/clock.c                    |    1 +
 arch/arm/mach-omap2/devices.c                  |    3 +-
 arch/arm/mach-omap2/hsmmc.c                    |    7 +-
 arch/arm/mach-omap2/iommu2.c                   |    4 +-
 arch/arm/mach-omap2/omap-iommu.c               |    2 +-
 arch/arm/mach-s3c64xx/Kconfig                  |   23 +
 arch/arm/mach-s3c64xx/Makefile                 |    1 +
 arch/arm/mach-s3c64xx/include/mach/irqs.h      |    4 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c          |  774 ++++++++++++++++++++++++
 arch/arm/plat-omap/dmtimer.c                   |    4 +-
 arch/arm/plat-omap/include/plat/omap4-keypad.h |    3 +-
 arch/arm/plat-omap/include/plat/uncompress.h   |    1 +
 arch/arm/plat-omap/iovmm.c                     |    6 +-
 20 files changed, 1233 insertions(+), 72 deletions(-)

