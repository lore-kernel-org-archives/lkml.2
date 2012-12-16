Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2LPMKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 07:10:39 -0500
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:24346 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2LPMKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 07:10:38 -0500
Date: Sun, 16 Dec 2012 22:18:44 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201212161218.qBGCIibN027429@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch updates for 3.8
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree, for-next branch, at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

This one has a major restructuring of the non-mmu 68000 support. It merges
all the related SoC types that use the original 68000 cpu core internally
so they can share the same core code. It also allows for supporting the
original stand alone 68000 cpu in its own right. There is also a
generalization of the clock support of the ColdFire parts, some merging of
common ColdFire code, and a couple of bug fixes as well.

Regards
Greg



The following changes since commit b69f0859dc8e633c5d8c06845811588fe17e68b3:
  Linus Torvalds (1):
        Linux 3.7-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

Greg Ungerer (15):
      m68knommu: merge ColdFire 5249 and 525x definitions
      m68knommu: make non-MMU page_to_virt() return a void *
      m68k: fix unused variable warning in mempcy.c
      m68knommu: add clock creation support macro for other ColdFire CPUs
      m68knommu: add clock definitions for 5206 ColdFire CPU types
      m68knommu: add clock definitions for 523x ColdFire CPU types
      m68knommu: add clock definitions for 5249 ColdFire CPU types
      m68knommu: add clock definitions for 525x ColdFire CPU types
      m68knommu: add clock definitions for 5272 ColdFire CPU types
      m68knommu: add clock definitions for 527x ColdFire CPU types
      m68knommu: add clock definitions for 528x ColdFire CPU types
      m68knommu: add clock definitions for 5307 ColdFire CPU types
      m68knommu: add clock definitions for 5407 ColdFire CPU types
      m68knommu: add clock definitions for 54xx ColdFire CPU types
      m68knommu: modify clock code so it can be used by all ColdFire CPU types

Luis Alves (3):
      m68knommu: platform code merge for 68000 core cpus
      m68knommu: allow for configuration of true 68000 based systems
      m68knommu: disable MC68000 cpu target when MMU is selected

 arch/m68k/Kconfig.cpu                              |    3 +-
 arch/m68k/Makefile                                 |    6 +-
 arch/m68k/include/asm/m5249sim.h                   |  269 --------------------
 arch/m68k/include/asm/m525xsim.h                   |  116 +++++++++-
 arch/m68k/include/asm/mcfclk.h                     |    9 +-
 arch/m68k/include/asm/mcfsim.h                     |    5 +-
 arch/m68k/include/asm/page_no.h                    |    2 +-
 arch/m68k/lib/memcpy.c                             |    3 +-
 arch/m68k/platform/68000/Makefile                  |   18 ++
 .../{68VZ328/bootlogo.h => 68000/bootlogo-vz.h}    |    0
 arch/m68k/platform/{68328 => 68000}/bootlogo.h     |    0
 arch/m68k/platform/{68328 => 68000}/entry.S        |    0
 arch/m68k/platform/68000/head.S                    |  240 +++++++++++++++++
 arch/m68k/platform/{68328 => 68000}/ints.c         |    2 +-
 .../platform/{68328/config.c => 68000/m68328.c}    |    2 +-
 .../{68EZ328/config.c => 68000/m68EZ328.c}         |    2 +-
 .../{68VZ328/config.c => 68000/m68VZ328.c}         |    4 +-
 arch/m68k/platform/{68328 => 68000}/romvec.S       |    2 +-
 arch/m68k/platform/{68328 => 68000}/timers.c       |    2 +-
 arch/m68k/platform/68328/Makefile                  |   21 --
 arch/m68k/platform/68328/head-de2.S                |  128 ----------
 arch/m68k/platform/68328/head-pilot.S              |  207 ---------------
 arch/m68k/platform/68328/head-ram.S                |  141 ----------
 arch/m68k/platform/68328/head-rom.S                |  105 --------
 arch/m68k/platform/68EZ328/Makefile                |    5 -
 arch/m68k/platform/68VZ328/Makefile                |    5 -
 arch/m68k/platform/coldfire/clk.c                  |  100 +++-----
 arch/m68k/platform/coldfire/intc-5249.c            |    8 +-
 arch/m68k/platform/coldfire/m5206.c                |   20 ++
 arch/m68k/platform/coldfire/m523x.c                |   28 ++
 arch/m68k/platform/coldfire/m5249.c                |   28 ++-
 arch/m68k/platform/coldfire/m525x.c                |   20 ++
 arch/m68k/platform/coldfire/m5272.c                |   26 ++
 arch/m68k/platform/coldfire/m527x.c                |   30 +++
 arch/m68k/platform/coldfire/m528x.c                |   28 ++
 arch/m68k/platform/coldfire/m5307.c                |   20 ++
 arch/m68k/platform/coldfire/m5407.c                |   20 ++
 arch/m68k/platform/coldfire/m54xx.c                |   26 ++
 38 files changed, 680 insertions(+), 971 deletions(-)
 delete mode 100644 arch/m68k/include/asm/m5249sim.h
 create mode 100644 arch/m68k/platform/68000/Makefile
 rename arch/m68k/platform/{68VZ328/bootlogo.h => 68000/bootlogo-vz.h} (100%)
 rename arch/m68k/platform/{68328 => 68000}/bootlogo.h (100%)
 rename arch/m68k/platform/{68328 => 68000}/entry.S (100%)
 create mode 100644 arch/m68k/platform/68000/head.S
 rename arch/m68k/platform/{68328 => 68000}/ints.c (98%)
 rename arch/m68k/platform/{68328/config.c => 68000/m68328.c} (97%)
 rename arch/m68k/platform/{68EZ328/config.c => 68000/m68EZ328.c} (97%)
 rename arch/m68k/platform/{68VZ328/config.c => 68000/m68VZ328.c} (98%)
 rename arch/m68k/platform/{68328 => 68000}/romvec.S (94%)
 rename arch/m68k/platform/{68328 => 68000}/timers.c (98%)
 delete mode 100644 arch/m68k/platform/68328/Makefile
 delete mode 100644 arch/m68k/platform/68328/head-de2.S
 delete mode 100644 arch/m68k/platform/68328/head-pilot.S
 delete mode 100644 arch/m68k/platform/68328/head-ram.S
 delete mode 100644 arch/m68k/platform/68328/head-rom.S
 delete mode 100644 arch/m68k/platform/68EZ328/Makefile
 delete mode 100644 arch/m68k/platform/68VZ328/Makefile
