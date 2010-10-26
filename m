Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0JZB0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:26:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57165 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab0JZB0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:26:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Mon, 25 Oct 2010 21:26:19 -0400
Message-Id: <1288056379-25299-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1287997207-30661-1-git-send-email-vapier@gentoo.org>
References: <1287997207-30661-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 229aebb873e29726b91e076161649cf45154b0bf:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial (2010-10-24 13:41:39 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Mike Frysinger (5):
      Blackfin: bfin_twi.h: start a common TWI header
      Blackfin: update defconfigs
      Blackfin: ppi/spi/twi headers: add missing __BFP undef
      Blackfin: drop unused irq_panic()/DEBUG_ICACHE_CHECK
      Blackfin: fix inverted anomaly 05000481 logic

Sonic Zhang (1):
      netdev: bfin_mac: push settings to platform resources

 arch/blackfin/Kconfig.debug                       |   11 --
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |    2 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |    2 +-
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |    2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |    3 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    3 +-
 arch/blackfin/configs/BF527-TLL6527M_defconfig    |    1 -
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |    2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |    3 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig       |    3 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    4 +-
 arch/blackfin/configs/BF561-ACVILON_defconfig     |    4 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    1 +
 arch/blackfin/configs/BlackStamp_defconfig        |    3 +-
 arch/blackfin/configs/CM-BF527_defconfig          |    4 +-
 arch/blackfin/configs/CM-BF533_defconfig          |    3 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |    3 +-
 arch/blackfin/configs/CM-BF537U_defconfig         |    3 +-
 arch/blackfin/configs/CM-BF548_defconfig          |    3 +-
 arch/blackfin/configs/CM-BF561_defconfig          |    3 +-
 arch/blackfin/configs/H8606_defconfig             |    3 +-
 arch/blackfin/configs/IP0X_defconfig              |    3 +-
 arch/blackfin/configs/PNAV-10_defconfig           |    2 +-
 arch/blackfin/configs/SRV1_defconfig              |    3 +-
 arch/blackfin/configs/TCM-BF518_defconfig         |    1 -
 arch/blackfin/configs/TCM-BF537_defconfig         |    2 +
 arch/blackfin/include/asm/bfin5xx_spi.h           |    2 +
 arch/blackfin/include/asm/bfin_ppi.h              |    2 +
 arch/blackfin/include/asm/bfin_twi.h              |   45 +++++++
 arch/blackfin/include/asm/cdef_LPBlackfin.h       |    2 +-
 arch/blackfin/mach-bf518/boards/ezbrd.c           |   44 ++++++-
 arch/blackfin/mach-bf518/boards/tcm-bf518.c       |   24 ++++-
 arch/blackfin/mach-bf527/boards/cm_bf527.c        |   24 ++++-
 arch/blackfin/mach-bf527/boards/ezbrd.c           |   24 ++++-
 arch/blackfin/mach-bf527/boards/ezkit.c           |   24 ++++-
 arch/blackfin/mach-bf527/boards/tll6527m.c        |   24 ++++-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c       |   24 ++++-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c       |   24 ++++-
 arch/blackfin/mach-bf537/boards/minotaur.c        |   24 ++++-
 arch/blackfin/mach-bf537/boards/pnav10.c          |   24 ++++-
 arch/blackfin/mach-bf537/boards/stamp.c           |   24 ++++-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c       |   24 ++++-
 arch/blackfin/mach-common/Makefile                |    1 -
 arch/blackfin/mach-common/irqpanic.c              |  106 ---------------
 drivers/net/Kconfig                               |    8 -
 drivers/net/bfin_mac.c                            |  145 +++++++++++++-------
 drivers/net/bfin_mac.h                            |    2 +
 include/linux/bfin_mac.h                          |   29 ++++
 49 files changed, 513 insertions(+), 216 deletions(-)
 create mode 100644 arch/blackfin/include/asm/bfin_twi.h
 delete mode 100644 arch/blackfin/mach-common/irqpanic.c
 create mode 100644 include/linux/bfin_mac.h
