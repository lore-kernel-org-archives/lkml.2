Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2AICv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:51:26 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:37963
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755267Ab2AICvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:51:23 -0500
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275dhz2ei87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, <sonic.zhang@analog.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [GIT PULL] blackfin changes for v3.3
Date: Mon, 9 Jan 2012 10:51:31 +0800
Message-ID: <1326077491-10800-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linus,

Please pull blackfin changes for v3.3.
Most are board related bugfix and code clean.

The following changes since commit a0e86bd4252519321b0d102dc4ed90557aa7bee9:
  Jesper Juhl (1):
        audit: always follow va_copy() with va_end()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus

Aaron Wu (1):
      blackfin: i2c-lcd: change default clock rate

Bob Liu (7):
      blackfin: bf533-stamp: fix ad1836 name
      blackfin: bf533-stamp: add missed patches for new asoc driver
      blackfin: smp: add suspend and wakeup irq flags
      blackfin: smp: cleanup smp code
      blackfin: time-ts: rm unused func broadcast_timer_setup()
      blackfin: bf537: add capture support
      blackfin: bf561: add adv7183 capture support

Scott Jiang (3):
      blackfin: config: update def config for all boards
      blackfin: bf537: change num_chipselect for spi-sport
      blackfin: bf548: add capture support

Sonic Zhang (2):
      blackfin: config: update macro SPI_BFIN in board file
      blackfin: serial: bfin-uart: remove unused field

Steven Miao (3):
      blackfin: smp: fix msg queue overflow issue
      bf54x: get mem size: missing break in switch
      blackfin: mac: dsa: add vlan mask in board file

 arch/blackfin/configs/BF518F-EZBRD_defconfig      |    2 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |    2 +-
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |    2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |    2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |    2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |    2 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF561-ACVILON_defconfig     |    2 +-
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig   |    2 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BlackStamp_defconfig        |    2 +-
 arch/blackfin/configs/CM-BF527_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF533_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |    2 +-
 arch/blackfin/configs/CM-BF537U_defconfig         |    2 +-
 arch/blackfin/configs/CM-BF548_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF561_defconfig          |    2 +-
 arch/blackfin/configs/DNP5370_defconfig           |    2 +-
 arch/blackfin/configs/H8606_defconfig             |    2 +-
 arch/blackfin/configs/IP0X_defconfig              |    2 +-
 arch/blackfin/configs/PNAV-10_defconfig           |    2 +-
 arch/blackfin/configs/SRV1_defconfig              |    2 +-
 arch/blackfin/configs/TCM-BF518_defconfig         |    2 +-
 arch/blackfin/configs/TCM-BF537_defconfig         |    2 +-
 arch/blackfin/include/asm/bfin_serial.h           |    3 -
 arch/blackfin/include/asm/cpu.h                   |    3 +
 arch/blackfin/include/asm/smp.h                   |    5 +-
 arch/blackfin/kernel/setup.c                      |   16 ++-
 arch/blackfin/kernel/time-ts.c                    |    8 +-
 arch/blackfin/mach-bf518/boards/ezbrd.c           |   10 +-
 arch/blackfin/mach-bf518/boards/tcm-bf518.c       |    4 +-
 arch/blackfin/mach-bf527/boards/ad7160eval.c      |    4 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c        |    4 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c           |    4 +-
 arch/blackfin/mach-bf527/boards/ezkit.c           |    4 +-
 arch/blackfin/mach-bf527/boards/tll6527m.c        |    4 +-
 arch/blackfin/mach-bf533/boards/H8606.c           |    6 +-
 arch/blackfin/mach-bf533/boards/blackstamp.c      |    4 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c        |    6 +-
 arch/blackfin/mach-bf533/boards/ezkit.c           |    4 +-
 arch/blackfin/mach-bf533/boards/ip0x.c            |    4 +-
 arch/blackfin/mach-bf533/boards/stamp.c           |  179 +++++++++++++++++++--
 arch/blackfin/mach-bf537/boards/cm_bf537e.c       |    6 +-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c       |    6 +-
 arch/blackfin/mach-bf537/boards/dnp5370.c         |    4 +-
 arch/blackfin/mach-bf537/boards/minotaur.c        |    6 +-
 arch/blackfin/mach-bf537/boards/pnav10.c          |    6 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |   78 +++++++++-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c       |    6 +-
 arch/blackfin/mach-bf538/boards/ezkit.c           |    6 +-
 arch/blackfin/mach-bf548/boards/cm_bf548.c        |    6 +-
 arch/blackfin/mach-bf548/boards/ezkit.c           |   73 ++++++++-
 arch/blackfin/mach-bf561/boards/acvilon.c         |    4 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c        |    6 +-
 arch/blackfin/mach-bf561/boards/ezkit.c           |  101 +++++++++++-
 arch/blackfin/mach-bf561/include/mach/pll.h       |    4 +-
 arch/blackfin/mach-bf561/smp.c                    |    5 +-
 arch/blackfin/mach-common/smp.c                   |   61 +++++--
 61 files changed, 570 insertions(+), 134 deletions(-)

