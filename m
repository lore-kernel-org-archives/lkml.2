Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2DWCE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 22:04:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:53449 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab2DWCE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 22:04:26 -0400
Message-ID: <1335146650.21619.3.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 23 Apr 2012 12:04:10 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few fixes for powerpc. Note the addition to the generic
irq.h. This is part of a 3-patches regression fix for mpic due to
changes in how IRQ_TYPE_NONE is being handled. Thomas agreed to the
addition of the new IRQ_TYPE_DEFAULT contant, however he hasn't
replied with an Ack to the actual patch yet. I don't to wait much
longer with these patches tho.

Cheers,
Ben.

The following changes since commit 932e9f352b5d685725076f21b237f7c7d804b29c:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security (2012-04-18 20:16:02 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 446f6d06fab0b49c61887ecbe8286d6aaa796637:

  powerpc/mpic: Properly set default triggers (2012-04-23 11:04:30 +1000)

----------------------------------------------------------------
Baruch Siach (1):
      powerpc: fix build when CONFIG_BOOKE_WDT is enabled

Benjamin Herrenschmidt (5):
      Merge remote-tracking branch 'kumar/merge' into merge
      powerpc/pmac: Don't add_timer() twice
      powerpc/mpic: Fix confusion between hw_irq and virq
      irq: Add IRQ_TYPE_DEFAULT for use by PIC drivers
      powerpc/mpic: Properly set default triggers

Gavin Shan (1):
      powerpc/eeh: Fix crash caused by null eeh_dev

Mingkai Hu (4):
      powerpc/mpic_msgr: fix compile error when SMP disabled
      powerpc/mpic_msgr: add lock for MPIC message global variable
      powerpc/mpic_msgr: fix offset error when setting mer register
      powerpc/mpc85xx: add MPIC message dts node

Timur Tabi (1):
      powerpc/85xx: don't call of_platform_bus_probe() twice

 arch/powerpc/boot/dts/fsl/pq3-mpic-message-B.dtsi |   43 ++++++++++++++++
 arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi           |   10 ++++
 arch/powerpc/include/asm/mpic.h                   |   18 -------
 arch/powerpc/include/asm/mpic_msgr.h              |    1 +
 arch/powerpc/include/asm/reg_booke.h              |    5 --
 arch/powerpc/kernel/setup_32.c                    |    3 ++
 arch/powerpc/platforms/85xx/common.c              |    6 +++
 arch/powerpc/platforms/85xx/mpc85xx_mds.c         |   11 +----
 arch/powerpc/platforms/85xx/p1022_ds.c            |   13 +----
 arch/powerpc/platforms/powermac/low_i2c.c         |    9 ++++
 arch/powerpc/platforms/pseries/eeh.c              |    2 +-
 arch/powerpc/sysdev/mpic.c                        |   54 +++++++++++++--------
 arch/powerpc/sysdev/mpic_msgr.c                   |   12 ++---
 include/linux/irq.h                               |    7 +++
 14 files changed, 122 insertions(+), 72 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-mpic-message-B.dtsi


