Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab2AQG6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 01:58:02 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62660 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2AQG6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 01:58:01 -0500
Date: Mon, 16 Jan 2012 22:58:04 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linuxfoundation.org
Cc: arnd@arndb.de, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm-soc fixes for 3.3-rc1
Message-ID: <20120117065804.GA31953@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Once the dmaengine pull request that was sent this morning lands, the remaining
dependencies for arm-soc pull requests should be resolved.

Until then, here is a batch of fixes for -rc1.

Thanks!

-Olof



The following changes since commit c2bc3a316a7281f67e36b34dac2802cbe36a9128:

  Merge branch 'x86/rdrand' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2012-01-16 18:23:09 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git arm-soc-fixes-20120116

for you to fetch changes up to 090e648a20a43d71fc2d63e0d8ff8ec6822e2396:

  Merge branch 'samsung-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2012-01-16 22:46:19 -0800)

----------------------------------------------------------------

ARM: fixes for ARM platforms

Some fallout from the 3.3. merge window as well as a couple bug fixes
for older preexisting bugs that seem valid to include at this time:

* sched_clock changes broke picoxcell, fix included
* BSYM bugs causing issues with thumb2-built kernels on SMP
* Missing module.h include on msm.
* A collection of bugfixes for samsung platforms that didn't make it into
  the first pull requests.

----------------------------------------------------------------
David Brown (1):
      ARM: msm: vreg is a module and so needs module.h

Jamie Iles (1):
      ARM: picoxcell: fix sched_clock() cleanup fallout

Mark Brown (7):
      ARM: SAMSUNG: Guard against multiple inclusion of plat/dma.h
      ARM: SAMSUNG: dma-ops.h needs mach/dma.h
      ARM: SAMSUNG: Declare struct platform_device in plat/s3c64xx-spi.h
      ARM: S3C64XX: Remove unconditional power domain disables
      ARM: S3C64XX: Remove hsmmc1 from Cragganmore
      ARM: S3C64XX: Fix the memory mapped GPIOs on Cragganmore
      ARM: S3C64XX: Fix interrupt configuration for PCA935x on Cragganmore

Olof Johansson (4):
      Merge branch 'picoxcell-fixes' of git://github.com/jamieiles/linux-2.6-ji into fixes
      Merge branch 'msm-fix' of git://codeaurora.org/quic/kernel/davidb/linux-msm into fixes
      Merge branch 'fixes-for-arm-soc' of git://sources.calxeda.com/kernel/linux into fixes
      Merge branch 'samsung-fixes' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Pawel Moll (1):
      ARM: versatile: Add missing ENDPROC to headsmp.S

Rob Herring (6):
      ARM: msm: Add missing ENDPROC to headsmp.S
      ARM: ux500: add missing ENDPROC to headsmp.S
      ARM: exynos: remove incorrect BSYM usage
      ARM: imx: remove incorrect BSYM usage
      ARM: highbank: remove incorrect BSYM usage
      ARM: make BSYM macro assembly only

Tushar Behera (1):
      ARM: EXYNOS: Invert VCLK polarity for framebuffer on ORIGEN

 arch/arm/include/asm/unified.h                   |    4 ++--
 arch/arm/mach-exynos/headsmp.S                   |    2 ++
 arch/arm/mach-exynos/mach-origen.c               |    3 ++-
 arch/arm/mach-exynos/platsmp.c                   |    5 ++---
 arch/arm/mach-highbank/highbank.c                |    3 +--
 arch/arm/mach-imx/src.c                          |    3 +--
 arch/arm/mach-msm/headsmp.S                      |    1 +
 arch/arm/mach-msm/vreg.c                         |    1 +
 arch/arm/mach-picoxcell/time.c                   |    2 +-
 arch/arm/mach-realview/platsmp.c                 |    3 +--
 arch/arm/mach-s3c64xx/include/mach/crag6410.h    |    1 +
 arch/arm/mach-s3c64xx/mach-crag6410.c            |   13 +++----------
 arch/arm/mach-s3c64xx/pm.c                       |   13 -------------
 arch/arm/mach-ux500/headsmp.S                    |    2 ++
 arch/arm/mach-vexpress/platsmp.c                 |    4 +---
 arch/arm/plat-samsung/include/plat/dma-ops.h     |    1 +
 arch/arm/plat-samsung/include/plat/dma.h         |    6 +++++-
 arch/arm/plat-samsung/include/plat/s3c64xx-spi.h |    2 ++
 arch/arm/plat-versatile/headsmp.S                |    1 +
 19 files changed, 30 insertions(+), 40 deletions(-)
