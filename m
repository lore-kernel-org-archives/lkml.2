Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab0EYGRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:17:25 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:51206 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752835Ab0EYGRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:17:23 -0400
Date: Tue, 25 May 2010 16:19:32 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <201005250619.o4P6JWIb018333@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
       <linux-m68k@vger.kernel.org>
Subject: [git pull] m68knommu arch updates
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Biggest change is the QSPI driver platform support. Also platform support
for the SMC91x driver on some ColdFire platforms. A couple of bug fixes,
and some cleanups as well.

Thanks
Greg




The following changes since commit e40152ee1e1c7a63f4777791863215e3faa37a86:
  Linus Torvalds (1):
        Linus 2.6.34

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Andrea Gelmini (2):
      arch/m68knommu/mm/fault.c: Checkpatch cleanup
      arch/m68knommu/platform/68360/commproc.c: Checkpatch cleanup

Greg Ungerer (5):
      m68knommu: fix broken use of BUAD_TABLE_SIZE in 68328serial driver
      m68knommu: remove size limit on non-MMU TASK_SIZE
      m68knommu: add smc91x support to ColdFire 5249 platform
      m68knommu: add smc91x support for ColdFire NETtel boards
      m68knommu: remove un-used mcfsmc.h

Philippe De Muyter (1):
      m68knommu: improve short help of m68knommu/Kconfig/RAMSIZE for '0' case

Steven King (1):
      m68knommu: Coldfire QSPI platform support

 arch/m68k/include/asm/m520xsim.h         |    1 +
 arch/m68k/include/asm/m523xsim.h         |    5 +
 arch/m68k/include/asm/m5249sim.h         |    2 +
 arch/m68k/include/asm/m527xsim.h         |    7 +
 arch/m68k/include/asm/m528xsim.h         |   67 +---------
 arch/m68k/include/asm/m532xsim.h         |    1 +
 arch/m68k/include/asm/mcfqspi.h          |   64 +++++++++
 arch/m68k/include/asm/mcfsmc.h           |  187 --------------------------
 arch/m68k/include/asm/processor.h        |    4 +
 arch/m68knommu/Kconfig                   |    2 +-
 arch/m68knommu/mm/fault.c                |   10 +-
 arch/m68knommu/platform/520x/config.c    |  149 +++++++++++++++++++++
 arch/m68knommu/platform/523x/config.c    |  170 +++++++++++++++++++++++
 arch/m68knommu/platform/5249/config.c    |  215 ++++++++++++++++++++++++++++++
 arch/m68knommu/platform/527x/config.c    |  182 +++++++++++++++++++++++++
 arch/m68knommu/platform/528x/config.c    |  137 +++++++++++++++++++
 arch/m68knommu/platform/5307/Makefile    |    4 +-
 arch/m68knommu/platform/5307/nettel.c    |  153 +++++++++++++++++++++
 arch/m68knommu/platform/532x/config.c    |  124 +++++++++++++++++
 arch/m68knommu/platform/68360/commproc.c |    4 +-
 drivers/serial/68328serial.c             |    2 +-
 21 files changed, 1227 insertions(+), 263 deletions(-)
 create mode 100644 arch/m68k/include/asm/mcfqspi.h
 delete mode 100644 arch/m68k/include/asm/mcfsmc.h
 create mode 100644 arch/m68knommu/platform/5307/nettel.c
