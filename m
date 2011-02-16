Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab1BPAbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:31:34 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:52781 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab1BPAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:31:31 -0500
Date: Wed, 16 Feb 2011 10:30:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201102160030.p1G0UObe004686@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>
Subject: [git pull] m68knommu arch bug fixes
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the following bug fixes for the m68knommu arch:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

A bunch of little things in here, mostly quite strait forward bug fixes. 
The memmove/memcmp regression caused by the string.h header merge ends
up making m68k and m68knommu more consistent in their arch libs. The
68x328 and 68360 families are not getting much love, so a number of
fixes for them in here too.

Thanks
Greg




The following changes since commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d:
  Linus Torvalds (1):
        Linux 2.6.38-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Geert Uytterhoeven (1):
      m68knommu: Remove dependencies on nonexistent M68KNOMMU

Greg Ungerer (8):
      m68knommu: fix use of un-defined _TIF_WORK_MASK
      m68k: remove arch specific non-optimized memcmp()
      m68knommu: add optimize memmove() function
      m68knommu: fix mis-named variable int set_irq_chip loop
      m68knommu: add missing linker __modver section
      m68knommu: fix dereference of port.tty
      m68knommu: remove use of IRQ_FLG_LOCK from 68360 platform support
      m68knommu: set flow handler for secondary interrupt controller of 5249

Philippe De Muyter (2):
      m68knommu: fix m548x_wdt.c compilation after headers renaming
      m68knommu: Rename m548x_wdt.c to m54xx_wdt.c

 arch/m68k/include/asm/string.h                |    4 +-
 arch/m68k/lib/string.c                        |   11 ---
 arch/m68knommu/kernel/vmlinux.lds.S           |    6 ++
 arch/m68knommu/lib/Makefile                   |    2 +-
 arch/m68knommu/lib/memmove.c                  |  105 +++++++++++++++++++++++++
 arch/m68knommu/platform/5249/intc2.c          |    4 +-
 arch/m68knommu/platform/68328/entry.S         |    1 -
 arch/m68knommu/platform/68360/commproc.c      |    2 +-
 arch/m68knommu/platform/68360/config.c        |    2 +-
 arch/m68knommu/platform/68360/entry.S         |    1 -
 arch/m68knommu/platform/68360/ints.c          |    4 +-
 arch/m68knommu/platform/coldfire/entry.S      |    1 -
 drivers/net/can/mscan/Kconfig                 |    2 +-
 drivers/tty/serial/68328serial.c              |   29 ++++----
 drivers/watchdog/Kconfig                      |    6 +-
 drivers/watchdog/Makefile                     |    2 +-
 drivers/watchdog/{m548x_wdt.c => m54xx_wdt.c} |   50 ++++++------
 lib/Kconfig.debug                             |    2 +-
 18 files changed, 165 insertions(+), 69 deletions(-)
 create mode 100644 arch/m68knommu/lib/memmove.c
 rename drivers/watchdog/{m548x_wdt.c => m54xx_wdt.c} (80%)
