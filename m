Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab2B2TWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:22:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282Ab2B2TWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:22:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland Stigge <stigge@antcom.de>
Subject: [GIT PULL] arm-soc fixes for v3.3
Date: Wed, 29 Feb 2012 19:22:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202291922.31251.arnd@arndb.de>
X-Provags-ID: V02:K0:iQdvNjIa2hOxXdgO5Q991TEl5hZoPVMXxzRWm5dNtPA
 DJ/9E/ChsjmVCPXd74zAk3kkUn3T2+5hqu+1MIUf8ABH9l5PUI
 9QDfSPHw19ltXbN98B9rZtXN4eUbxaoF/+cYRjNr4i4W2+v0KO
 PJV67KRmvCsYcscRECJaiMOs+XcFr727xNv9DaY9XzdZS7dIxD
 WSoswqjN5ip/ix2hVIHv9Mo+L4I1kS2kwrGgWoaFOOlT+A6PD4
 62qbRHuudXL+4O13SmeSYpV9969PfCmvRKpnCweo/StQguVe2a
 v+v6PxCcJg2AU/T4GdYvJG1QCMxqE26fOFDEqIjG1Lw+O5DPy8
 IZToHhNqA6fFOEb7EXns=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is another set of arm-soc bug fixes on top of v3.3-rc5. The few larger
bits are all for devices that still need to get set up in board code.

Only three platforms are in this set of fixes: omap2+, pxa and lpc32xx.

	Arnd

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes-3.3-rc6

Arnd Bergmann (3):
      Merge branch 'fixes' of git://github.com/hzhuang1/linux into fixes
      Merge branch 'fixes' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'lpc32xx/fixes' of git://git.antcom.de/linux-2.6 into fixes

Arnout Vandecappelle (Essensium/Mind) (1):
      OMAP3 EVM: remove out-of-bounds array access of gpio_leds

Axel Lin (2):
      ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe
      pxa/hx4700: add platform device and I2C info for AK4641 codec

Danny Kukawka (3):
      ARM: pxa: fix including linux/gpio.h twice
      arch/arm/mach-mmp/: some files include some headers twice
      arch/arm/mach-pxa/: included linux/gpio.h twice

Felipe Balbi (1):
      ARM: OMAP2+: usb-host: fix compile warning

Haojian Zhuang (2):
      ARM: pxa: fix wrong parsing gpio event on spitz
      ARM: pxa: fix mixed declarations and code in sharpsl_pm

Matt Porter (1):
      ARM: OMAP2+: gpmc-smsc911x: add required smsc911x regulators

NeilBrown (1):
      ARM: OMAP: add RCU locking to omap2_set_init_voltage.

Ohad Ben-Cohen (1):
      ARM: OMAP2: fix mailbox init code

Roland Stigge (5):
      ARM: LPC32xx: Fix irq on GPI_28
      ARM: LPC32xx: Fix interrupt controller init
      ARM: LPC32xx: irq.c: Clear latched event
      ARM: LPC32xx: serial.c: HW bug workaround
      ARM: LPC32xx: serial.c: Fixed loop limit

Santosh Shilimkar (2):
      ARM: OMAP4: cpuidle: Fix the C-state reporting to cpuidle governor.
      ARM: OMAP4: Move the barrier memboclk_steal() as part of reserve callback

Tony Lindgren (5):
      Merge branch 'for_3.3/fixes/pm' of git://git.kernel.org/.../khilman/linux-omap-pm into fixes
      ARM: OMAP: Fix kernel panic with HSMMC when twl4030_gpio is a module
      ARM: OMAP: Fix build error when mmc_omap is built as module
      Merge branch 'fixes-mmc' into fixes
      ARM: OMAP1: Fix out-of-bounds array access for Innovator

 arch/arm/mach-lpc32xx/include/mach/irqs.h     |    2 +-
 arch/arm/mach-lpc32xx/irq.c                   |   25 +++++++++--
 arch/arm/mach-lpc32xx/serial.c                |   20 +++++++++-
 arch/arm/mach-mmp/aspenite.c                  |    1 -
 arch/arm/mach-mmp/pxa168.c                    |    1 -
 arch/arm/mach-mmp/tavorevb.c                  |    1 -
 arch/arm/mach-omap1/board-innovator.c         |    4 +-
 arch/arm/mach-omap2/Kconfig                   |    4 +-
 arch/arm/mach-omap2/board-n8x0.c              |    4 ++
 arch/arm/mach-omap2/board-omap3evm.c          |    2 +-
 arch/arm/mach-omap2/common.h                  |    1 +
 arch/arm/mach-omap2/cpuidle44xx.c             |    5 +-
 arch/arm/mach-omap2/gpmc-smsc911x.c           |   52 +++++++++++++++++++++++++
 arch/arm/mach-omap2/hsmmc.c                   |    6 +++
 arch/arm/mach-omap2/io.c                      |    1 +
 arch/arm/mach-omap2/mailbox.c                 |   10 ++++-
 arch/arm/mach-omap2/mux.c                     |    2 +-
 arch/arm/mach-omap2/omap4-common.c            |   25 ++++++++----
 arch/arm/mach-omap2/pm.c                      |    3 +
 arch/arm/mach-omap2/usb-host.c                |    6 +-
 arch/arm/mach-pxa/hx4700.c                    |   25 ++++++++++++
 arch/arm/mach-pxa/pxa25x.c                    |    1 -
 arch/arm/mach-pxa/pxa27x.c                    |    1 -
 arch/arm/mach-pxa/saarb.c                     |    1 -
 arch/arm/mach-pxa/sharpsl_pm.c                |    3 +-
 arch/arm/mach-pxa/spitz_pm.c                  |    5 +-
 arch/arm/plat-omap/common.c                   |    1 +
 arch/arm/plat-omap/include/plat/omap-secure.h |    6 +++
 drivers/pcmcia/pxa2xx_base.c                  |   12 +----
 29 files changed, 181 insertions(+), 49 deletions(-)
