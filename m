Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2E3Xkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 19:40:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2E3Xkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 19:40:45 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
Date: Wed, 30 May 2012 16:40:44 -0700
Message-ID: <CAOesGMiFNJK528g0qyiswbNijJFBckuNTMG=sz98c9BEpRJwHg@mail.gmail.com>
Subject: [GIT PULL] arm-soc: late-merged development and first fixes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is one aggregate request for the remaining arm-soc pull. Since
there is only a handful of patches in total, doing individual topic
requests seemed silly.


Thanks!

-Olof



The following changes since commit af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
(2012-05-30 11:17:19 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/devel-late

for you to fetch changes up to 47e1993d32d4e0f9524c2147576468fe11e87b5f:

  Merge branches 'fixes' and 'fixes2' into devel-late (2012-05-30
16:16:12 -0700)

----------------------------------------------------------------

arm-soc: late-merged development and first fixes

This branch contains a few development patches for Samsung and Versatile
Express that were submitted to arm-soc near the beginning of the merge
window. We picked them up with the agreement that they would need to
sit in linux-next for a while, and now they have.

There are also two fixes:
- One long-standing build breakage on ixp4xx due to missing gpiolib
  dependencies.
- The other is for some gpio device tree changes needed on lpc32xx.

----------------------------------------------------------------
Daniel Lezcano (2):
      ARM: S3C64XX: declare the states with the new api on cpuidle
      ARM: S3C64XX: use timekeeping wrapper on cpuidle

Heiko Stuebner (1):
      ARM: S3C24XX: add support for second irq set of S3C2416

Jongpill Lee (5):
      ARM: EXYNOS: Remove GIC save & restore function
      ARM: EXYNOS: Rename of function for pm.c
      ARM: EXYNOS: Add PMU table for EXYNOS5250
      ARM: EXYNOS: Add Clock register list for save and restore
      ARM: EXYNOS: Support suspend and resume for EXYNOS5250

Kukjin Kim (2):
      Merge branch 'next/devel-samsung' into next/devel-samsung-2
      Merge branch 'next/devel-exynos5250-1' into next/devel-samsung-2

Mark Brown (2):
      ARM: S3C64XX: Initial hookup for Bells module on Cragganmore
      ARM: S3C64XX: Hook up carrier class modules on Cragganmore

Olof Johansson (8):
      Merge branch 'next/cleanup-samsung-2' of
git://git.kernel.org/.../kgene/linux-samsung into late/cleanup
      Merge branch 'next/devel-samsung-2' of
git://git.kernel.org/.../kgene/linux-samsung into late/soc
      Merge branch 'next/board-samsung-2' of
git://git.kernel.org/.../kgene/linux-samsung into late/board
      Merge branch 'vexpress-v3.4' of
git://git.linaro.org/people/pawelmoll/linux into late/soc
      Merge branch 'late/cleanup' into devel-late
      Merge branch 'late/soc' into devel-late
      Merge branch 'late/board' into devel-late
      Merge branches 'fixes' and 'fixes2' into devel-late

Pawel Moll (1):
      ARM: vexpress: Device Tree updates

Richard Cochran (1):
      ixp4xx: fix compilation by adding gpiolib support

Roland Stigge (1):
      ARM: LPC32xx: Adjust dts files to gpio dt binding

Thomas Abraham (1):
      ARM: dts: Add node for interrupt combiner controller on EXYNOS5250

Thomas Weber (1):
      ARM: vexpress: Remove twice included header files

 arch/arm/Kconfig                               |   2 +-
 arch/arm/boot/dts/exynos5250.dtsi              |  16 ++
 arch/arm/boot/dts/lpc32xx.dtsi                 |  41 +----
 arch/arm/boot/dts/phy3250.dts                  |   4 +-
 arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts    |  13 +-
 arch/arm/boot/dts/vexpress-v2p-ca5s.dts        |  13 +-
 arch/arm/boot/dts/vexpress-v2p-ca9.dts         |   9 +-
 arch/arm/mach-exynos/Kconfig                   |   2 +
 arch/arm/mach-exynos/Makefile                  |   2 +-
 arch/arm/mach-exynos/clock-exynos5.c           |  51 +++++-
 arch/arm/mach-exynos/cpuidle.c                 |   2 +-
 arch/arm/mach-exynos/include/mach/pm-core.h    |   2 +-
 arch/arm/mach-exynos/include/mach/pmu.h        |   4 +-
 arch/arm/mach-exynos/include/mach/regs-clock.h |  18 +-
 arch/arm/mach-exynos/include/mach/regs-pmu.h   | 141 +++++++++++++++-
 arch/arm/mach-exynos/pm.c                      | 223 +++++++++----------------
 arch/arm/mach-exynos/pmu.c                     | 200 ++++++++++++++++++++--
 arch/arm/mach-ixp4xx/common.c                  |  48 +++++-
 arch/arm/mach-ixp4xx/include/mach/gpio.h       |  79 +--------
 arch/arm/mach-s3c24xx/include/mach/irqs.h      |  15 +-
 arch/arm/mach-s3c24xx/irq-s3c2416.c            |  98 +++++++++++
 arch/arm/mach-s3c24xx/s3c2416.c                |   1 +
 arch/arm/mach-s3c64xx/cpuidle.c                |  45 ++---
 arch/arm/mach-s3c64xx/mach-crag6410-module.c   |   9 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c          |   1 +
 arch/arm/mach-vexpress/v2m.c                   |   2 -
 arch/arm/plat-samsung/include/plat/s3c2416.h   |   3 +
 27 files changed, 706 insertions(+), 338 deletions(-)
