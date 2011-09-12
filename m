Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab1ILQHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:07:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab1ILQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:07:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for 3.1
Date: Mon, 12 Sep 2011 18:07:45 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109121807.45377.arnd@arndb.de>
X-Provags-ID: V02:K0:KBdHq6WxM/NKg3CqzmNocys+8xz37x0U3q4uqhWKc5V
 gfVc2RoGle5lKBTcJxPsZGGjGmdebksWn1irwkVp2TrjPc7QF3
 N7r+gC855WDX7XjeAqDmYGUE3LgjO4d5+LiUxRr/xfwg2hz7Og
 D/D73KP4H/9/5vhzX4q0WWhUXKSXtRE5j7Zc2it2216Ah0KvcQ
 fZb81dpU3myJJYBaF6ala4oBeyG0RPceL/kp/TJmPrU4XhIPBp
 3Gt1aDeD1ZwQDOboOx68k9xGYwRhn0VVz/zTYfzCYl7cchM8Qd
 c1ICYon58KZLwxAf+3Tcknow9cniZJHQybRlx6HkGu1/i5reuQ
 VKvWdeS/5uFFEV4FWZjg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I've moved a copy of the arm-soc tree to git.linaro.org for now. Since
g.k.o contains to be unavailable, that seemed to be the most reliable
alternative for me.

The fixes for 3.1 that have come in during this time are for four platforms:
cns3xxx, davinci, omap2+, and prima2. I have a large set of build fixes
that I found myself during randconfig builds, but most of these have been
around forever, so I'm waiting for the merge window with those. I'm trying
to feed the actual build regressions through the individual maintainers,
so a few of those might be still be coming.

	Arnd

The following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:

  Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)

are available in the git repository at:
 git://git.linaro.org/people/arnd/arm-soc.git fixes

Anton Vorontsov (1):
      ARM: cns3xxx: Fix newly introduced warnings in the PCIe code

Arnd Bergmann (2):
      Merge branches 'cns3xxx/fixes', 'omap/fixes' and 'davinci/fixes' into fixes
      Merge branch 'sirf/fixes' into fixes

Jamie Iles (1):
      ARM: CSR: add missing sentinels to of_device_id tables

Linus Walleij (1):
      ARM: davinci: fix cache flush build error

Paul Walmsley (5):
      OMAP4: clock: re-enable previous clockdomain enable/disable sequence
      OMAP4: clock: fix compile warning
      OMAP3: clock: indicate that gpt12_fck and wdt1_fck are in the WKUP clockdomain
      OMAP2430: hwmod: musb: add missing terminator to omap2430_usbhsotg_addrs[]
      Merge branches 'non_hwmod_compliant_fix_3.1rc', 'omap3_clock_fixes_3.1rc', 'omap4_clock_fixes_3.1rc', 'missing_2430_musb_adds_terminator_fix_3.1rc' and 'pwrdm_clkdm_fixes_3.1rc' into prcm-fixes-a-3.1rc

Rajashekhara, Sudhakar (1):
      ARM: davinci: da850 EVM: read mac address from SPI flash

Rajendra Nayak (1):
      OMAP: powerdomains: Make all powerdomain target states as ON at init

Santosh Shilimkar (1):
      OMAP: clockdomain: Wait for powerdomain to be ON when using clockdomain force wakeup

Sergei Shtylyov (1):
      ARM: davinci: correct MDSTAT_STATE_MASK

Tommy Lin (1):
      ARM: cns3xxx: Fix compile error caused by hardware.h removed

 arch/arm/mach-cns3xxx/include/mach/entry-macro.S |    1 -
 arch/arm/mach-cns3xxx/include/mach/system.h      |    1 -
 arch/arm/mach-cns3xxx/include/mach/uncompress.h  |    1 -
 arch/arm/mach-cns3xxx/pcie.c                     |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c          |   28 ++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/psc.h         |    2 +-
 arch/arm/mach-davinci/sleep.S                    |    6 ++++-
 arch/arm/mach-omap2/clock3xxx_data.c             |    2 +
 arch/arm/mach-omap2/clock44xx_data.c             |   10 +++++++-
 arch/arm/mach-omap2/clockdomain.c                |    2 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c       |    1 +
 arch/arm/mach-omap2/pm.c                         |    2 -
 arch/arm/mach-omap2/powerdomain.c                |   25 ++++++++++++-------
 arch/arm/mach-prima2/clock.c                     |    1 +
 arch/arm/mach-prima2/irq.c                       |    1 +
 arch/arm/mach-prima2/rstc.c                      |    1 +
 arch/arm/mach-prima2/timer.c                     |    1 +
 17 files changed, 69 insertions(+), 18 deletions(-)
