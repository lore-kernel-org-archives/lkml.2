Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2JEOkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:40:10 -0400
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:31493 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2JEOkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:40:07 -0400
Date: Fri, 5 Oct 2012 16:23:58 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201210050623.q956NwaA011361@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch updates for 3.7
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

Most of it is a cleanup of the ColdFire hardware header files. We have had
a few occurrances of bugs caused by inconsistent definitions of peripheral
addresses. These patches make them all consistent, and also clean out a
bunch of old crap. Overall we remove about 1000 lines.

Regards
Greg



The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:
  Linus Torvalds (1):
        Linux 3.6-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

Greg Ungerer (25):
      m68knommu: make ColdFire IMR and IPR register definitions absolute addresses
      m68knommu: make ColdFire SYPCR and RSR register definitions absolute addresses
      m68knommu: make ColdFire watchdog register definitions absolute addresses
      m68knommu: make ColdFire Pin Assignment register definitions absolute addresses
      m68knommu: make ColdFire Interrupt Source register definitions absolute addresses
      m68knommu: make ColdFire Chip Select register definitions absolute addresses
      m68knommu: make ColdFire Park and Assignment register definitions absolute addresses
      m68knommu: make remaining ColdFire 5272 register definitions absolute addresses
      m68knommu: make ColdFire 5249 MBAR2 register definitions absolute addresses
      m68knommu: fix wrong register offsets used for ColdFire 5272 multi-function pins
      m68knommu: remove unused ColdFire 5282 register definitions
      m68knommu: remove address offsets relative to IPSBAR for ColdFire 527x
      m68knommu: use definitions for the ColdFire 528x FEC multi-function pins
      m68knommu: remove a lot of unsed definitions for 532x ColdFire
      m68knommu: modify ColdFire 532x GPIO register definitions to be consistent
      m68knommu: use read/write IO access functions in ColdFire m532x setup code
      m68knommu: move ColdFire slice timer address defiens to 54xx header
      m68knommu: fix multi-function pin setup for FEC module on ColdFire 523x
      m68knommu: clean up Pin Assignment definitions for the 54xx ColdFire CPU
      m68knommu: clean up ColdFire 54xx General Timer definitions
      m68knommu: fix inconsistent formating in ColdFire 523x definitions
      m68knommu: fix inconsistent formating in ColdFire 5272 definitions
      m68knommu: fix inconsistent formating in ColdFire 527x definitions
      m68knommu: fix inconsistent formating in ColdFire 5307 definitions
      m68knommu: fix inconsistent formating in ColdFire 5407 definitions

Paul Bolle (1):
      m68k: drop unused parts of 68VZ328 Makefile

Philippe De Muyter (1):
      m68knommu: use "r", not "i" constraint in cacheflush asm's

 arch/m68k/include/asm/cacheflush_no.h   |   19 +-
 arch/m68k/include/asm/m5206sim.h        |   98 ++--
 arch/m68k/include/asm/m523xsim.h        |   24 +-
 arch/m68k/include/asm/m5249sim.h        |   98 ++--
 arch/m68k/include/asm/m525xsim.h        |   68 +-
 arch/m68k/include/asm/m5272sim.h        |   99 ++--
 arch/m68k/include/asm/m527xsim.h        |   84 ++-
 arch/m68k/include/asm/m528xsim.h        |   51 +--
 arch/m68k/include/asm/m5307sim.h        |  136 ++--
 arch/m68k/include/asm/m532xsim.h        | 1189 ++-----------------------------
 arch/m68k/include/asm/m5407sim.h        |  110 ++--
 arch/m68k/include/asm/m54xxgpt.h        |   40 +-
 arch/m68k/include/asm/m54xxsim.h        |   27 +-
 arch/m68k/include/asm/mcfslt.h          |    7 -
 arch/m68k/include/asm/nettel.h          |    9 +-
 arch/m68k/platform/68VZ328/Makefile     |    8 +-
 arch/m68k/platform/coldfire/device.c    |    4 +-
 arch/m68k/platform/coldfire/head.S      |    2 +-
 arch/m68k/platform/coldfire/intc-5249.c |   10 +-
 arch/m68k/platform/coldfire/intc-5272.c |   20 +-
 arch/m68k/platform/coldfire/intc.c      |   28 +-
 arch/m68k/platform/coldfire/m523x.c     |    8 +-
 arch/m68k/platform/coldfire/m5249.c     |   10 +-
 arch/m68k/platform/coldfire/m525x.c     |    4 +-
 arch/m68k/platform/coldfire/m5272.c     |   19 +-
 arch/m68k/platform/coldfire/m527x.c     |   24 +-
 arch/m68k/platform/coldfire/m528x.c     |    6 +-
 arch/m68k/platform/coldfire/m532x.c     |  221 +++---
 arch/m68k/platform/coldfire/m54xx.c     |   16 +-
 arch/m68k/platform/coldfire/nettel.c    |    4 +-
 arch/m68k/platform/coldfire/pci.c       |    4 +-
 arch/m68k/platform/coldfire/reset.c     |    2 +-
 arch/m68k/platform/coldfire/sltimers.c  |    4 +-
 arch/m68k/platform/coldfire/timers.c    |    4 +-
 drivers/watchdog/m54xx_wdt.c            |   21 +-
 35 files changed, 701 insertions(+), 1777 deletions(-)
