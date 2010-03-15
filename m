Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965741Ab0COTOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:14:12 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:49419 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965718Ab0COTN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:13:58 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+MUeDg4tsAWBUbZSjADRA6
Date: Mon, 15 Mar 2010 12:15:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] omap fixes for 2.6.34-rc1
Message-ID: <20100315191523.GA2900@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Aaro Koskinen (2):
      omap: pass the reboot command to the boot loader
      omap: mach-omap2/io.c: fix function declarations

Andrea Gelmini (1):
      omap: Checkpatch cleanup for blizzard.h

Andrew Clayton (1):
      ARM/OMAP: Remove the +x bit from a couple of source files

Enric Balletbo i Serra (1):
      omap3: Fix support for the LEDs connected to GPIO outputs on IGEP v2board

Felipe Balbi (1):
      omap2/3/4: ehci: avoid compiler error with touchbook

Francisco Alecrim (1):
      omap2: add USB initialization for tusb6010

Grazvydas Ignotas (1):
      omap3: pandora: add missing i2c3 board_info

Janusz Krzysztofik (1):
      omap: McBSP: Drop unnecessary status/error bit clearing on reg_cacheretrieved register values

Kevin Hilman (2):
      OMAP2: cpu_is_omap2*: fix compile-time removal of unused code
      OMAP4: fix temporary hacks that break multi-omap PM

Santosh Shilimkar (1):
      omap4: Fix build break by moving omap_smc1 into a separate .S

Sergio Aguirre (1):
      omap: Fix gpio_resume_after_retention

Suman Anna (1):
      omap2/3/4: mailbox: remove compiler warning

Thomas Weber (1):
      OMAP2: serial.c: Fix number of uarts in early_init

Tony Lindgren (3):
      omap3: Fix compile for Touch Book early_param
      omap2: Update n8x0 defconfig to test multi-omap and DMA api changes
      omap: Enable PM_RUNTIME in defconfigs to avoid USB compile errors

 arch/arm/configs/cm_t35_defconfig            |    2 +-
 arch/arm/configs/n770_defconfig              |    1 +
 arch/arm/configs/n8x0_defconfig              |  160 +++++++++++++++++++++++---
 arch/arm/configs/omap3_beagle_defconfig      |    1 +
 arch/arm/configs/omap3_defconfig             |    2 +-
 arch/arm/configs/omap3_evm_defconfig         |    1 +
 arch/arm/configs/omap3_touchbook_defconfig   |    2 +-
 arch/arm/configs/omap_3430sdp_defconfig      |    1 +
 arch/arm/configs/omap_3630sdp_defconfig      |    2 +-
 arch/arm/configs/omap_h2_1610_defconfig      |    1 +
 arch/arm/configs/omap_zoom2_defconfig        |    1 +
 arch/arm/configs/omap_zoom3_defconfig        |    2 +-
 arch/arm/configs/rx51_defconfig              |    1 +
 arch/arm/mach-omap2/Makefile                 |    3 +
 arch/arm/mach-omap2/board-3430sdp.c          |    2 +-
 arch/arm/mach-omap2/board-3630sdp.c          |    2 +-
 arch/arm/mach-omap2/board-4430sdp.c          |   26 +----
 arch/arm/mach-omap2/board-am3517evm.c        |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c           |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c       |    2 +-
 arch/arm/mach-omap2/board-igep0020.c         |   56 ++++++---
 arch/arm/mach-omap2/board-n8x0.c             |   98 ++++++++++++++++
 arch/arm/mach-omap2/board-omap3beagle.c      |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c     |   12 ++-
 arch/arm/mach-omap2/board-omap3touchbook.c   |   12 +-
 arch/arm/mach-omap2/board-overo.c            |    2 +-
 arch/arm/mach-omap2/board-zoom3.c            |    2 +-
 arch/arm/mach-omap2/clock2420_data.c         |    1 +
 arch/arm/mach-omap2/io.c                     |   21 ++--
 arch/arm/mach-omap2/mailbox.c                |   12 +-
 arch/arm/mach-omap2/omap44xx-smc.S           |   32 +++++
 arch/arm/mach-omap2/prcm.c                   |    4 +-
 arch/arm/mach-omap2/serial.c                 |   15 ++-
 arch/arm/mach-omap2/usb-ehci.c               |    6 +-
 arch/arm/plat-omap/gpio.c                    |   10 +-
 arch/arm/plat-omap/include/plat/blizzard.h   |    2 +-
 arch/arm/plat-omap/include/plat/cpu.h        |    8 +-
 arch/arm/plat-omap/include/plat/prcm.h       |    2 +-
 arch/arm/plat-omap/include/plat/system.h     |    6 +-
 arch/arm/plat-omap/include/plat/usb.h        |    2 +-
 arch/arm/plat-omap/mcbsp.c                   |   12 +--
 42 files changed, 403 insertions(+), 132 deletions(-)
 mode change 100755 => 100644 arch/arm/mach-omap2/board-3630sdp.c
 mode change 100755 => 100644 arch/arm/mach-omap2/board-zoom-peripherals.c
 create mode 100644 arch/arm/mach-omap2/omap44xx-smc.S
