Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1H2UlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 16:41:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab1H2UlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:41:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [GIT PULL] arm-soc fixes for 3.1-rc4
Date: Mon, 29 Aug 2011 22:40:11 +0200
Message-ID: <2227519.rE44Tt1lqi@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/vWiY7i/KwNiBEXnXQqFxU2D41N3yqd3i67/EPgTy1k
 pDAc09kUMHg2JE+3a3KirNu6f5vfG1d7wXExEXDsT0Opsd7ggk
 3oeAwRtRhpFxocbAnj3wDV/fxfCAicMWOuAZ7mqJW/pqmEPt7m
 zhco5xLBDVcYrYtXuphqxsC6o5ueekySNO7CAWmFIoSTFmJiHi
 cIs1aVTAqhOyGiy/mHLLPXldHkfsR7AAwCDTq3QPyJ80uo/T/C
 XPKn+jgjl24gR43qU/7PcIPn9A3uo9HBYzO0g0UjFDhhIwSU18
 qwcHmYjSBNRvGZijMLjpMr/ldjUB8YiCfmgkot3tyvA3MBLBba
 1sTVChb7mVRtP5YRbdLc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are a bunch of bug fixes that have accumulated since the ones
I sent you for -rc2. I had planned to send these last week already
but didn't get to it. The good news is that they've seen more testing
this way.

	Arnd

The following changes since commit fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c:

  Linux 3.1-rc3 (2011-08-22 11:42:53 -0700)

are available in the git repository at:
  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ fixes

Abhilash Kesavan (2):
      ARM: S5PV210: Fix build warning
      ARM: S3C64XX: Fix build break in PM debug

Arnd Bergmann (3):
      Merge branch 'samsung/fixes' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into fixes
      Merge branch 'fixes' of git://git.jdl.com/software/linux-3.0 into fixes
      Merge branch 'at91/fixes' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into fixes

Bryan Wu (2):
      ARM: mach-orion5x: add missing header file <linux/vga.h>
      ARM: mach-footbridge: add missing header file <video/vga.h>

Huang Weiyi (1):
      ARM: EXYNOS4: remove duplicated inclusion

Jean-Christophe PLAGNIOL-VILLARD (1):
      at91: at91sam9261.c: fix typo in t2_clk alias for atmel_tcb.0

Jonghwan Choi (1):
      ARM: EXYNOS4: Fix wrong devname to support clkdev

Kukjin Kim (2):
      ARM: S5P64X0: Replace irq_gc_ack() with irq_gc_ack_set_bit()
      ARM: SAMSUNG: Fix Section mismatch in samsung_bl_set()

Kyungmin Park (2):
      ARM: EXYNOS4: Use the correct regulator names on universal_c210
      ARM: EXYNOS4: Add restart hook for proper reboot

Marek Szyprowski (3):
      ARM: SAMSUNG: Add chained enrty/exit call to timer interrupt handler
      ARM: EXYNOS4: add required chained_irq_enter/exit to eint code
      ARM: S5P: add required chained_irq_enter/exit to gpio-int code

Naveen Krishna Chatradhi (1):
      ARM: S5P: fix bug in spdif_clk_get_rate

Paul Gortmaker (1):
      arm: fix compile failure in orion5x/dns323-setup.c

Sylwester Nawrocki (1):
      ARM: EXYNOS4: Fix the IRQ definitions for MIPI CSIS device

Yulgon Kim (1):
      ARM: EXYNOS4: Increase reset delay for USB HOST PHY

 arch/arm/mach-at91/at91sam9261.c               |    2 +-
 arch/arm/mach-exynos4/clock.c                  |    2 +-
 arch/arm/mach-exynos4/cpu.c                    |   11 ++++++++++-
 arch/arm/mach-exynos4/include/mach/irqs.h      |    5 ++---
 arch/arm/mach-exynos4/include/mach/regs-pmu.h  |    2 ++
 arch/arm/mach-exynos4/irq-eint.c               |    7 +++++++
 arch/arm/mach-exynos4/mach-universal_c210.c    |    4 ++--
 arch/arm/mach-exynos4/setup-usb-phy.c          |    2 +-
 arch/arm/mach-footbridge/dc21285.c             |    1 +
 arch/arm/mach-orion5x/dns323-setup.c           |    2 +-
 arch/arm/mach-orion5x/pci.c                    |    1 +
 arch/arm/mach-s3c64xx/pm.c                     |    1 +
 arch/arm/mach-s5p64x0/irq-eint.c               |    2 +-
 arch/arm/mach-s5pv210/pm.c                     |    2 +-
 arch/arm/plat-s5p/clock.c                      |    2 +-
 arch/arm/plat-s5p/irq-gpioint.c                |    6 ++++++
 arch/arm/plat-samsung/include/plat/backlight.h |    2 +-
 arch/arm/plat-samsung/irq-vic-timer.c          |    5 +++++
 18 files changed, 45 insertions(+), 14 deletions(-)

