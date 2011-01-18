Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1ARKpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 05:45:24 -0500
Received: from outbound-mail01.westnet.com.au ([203.10.1.242]:54975 "EHLO
	outbound-mail01.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab1ARKpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 05:45:19 -0500
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2011 05:45:18 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMSAFf8NE18lCqXPGdsb2JhbAAMiE2cCAEBAQE1wxWDC4JFBA
X-IronPort-AV: E=Sophos;i="4.60,338,1291564800"; 
   d="scan'208";a="124224273"
Message-ID: <4D356D04.9080202@westnet.com.au>
Date: Tue, 18 Jan 2011 20:35:48 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: gerg@snapgear.com, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [git pull] m68knommu arch updates
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

(I would normally send this from my gerg@snapgear.com email account,
but the server and routers for that have been under water recently :-(
Not sure when I will be able to get that back working again).

Can you please pull the m68knommu git tree, for-linus branch.

   git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git 
for-linus

The most significant changes are:

1. using separate user and supervisor stack pointers on ColdFire
    parts that support it
2. reworking the CPU cache support, it now supports all forms of
    instruction and data cache on various ColdFire family members

Quite a few other cleanups and some random fixes in there too. The 548x
support has been made more generic and supports the 547x family as well.
A bit of dead code removal as well.

Thanks
Greg



The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:
   Linus Torvalds (1):
         Linux 2.6.37

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git 
for-linus

Greg Ungerer (21):
       m68knommu: make Coldfire 548x support more generic
       m68knommu: add support for the ColdFire 547x family of processors
       m68knommu: move ColdFire CPU names into their headers
       m68knommu: fix clock rate value reported for ColdFire 54xx parts
       m68knommu: move UART addressing to part specific includes
       m68knommu: remove fasthandler interrupt code
       m68knommu: remove command line printing DEBUG
       m68knommu: use user stack pointer hardware on some ColdFire cores
       m68knommu: remove do_page_fault(), it is not used
       m68knommu: remove kernel_map() code, it is not used
       m68knommu: remove empty __iounmap() it is no used
       m68knommu: create bit definitions for the version 2 ColdFire 
cache controller
       m68knommu: merge bit definitions for version 3 ColdFire cache 
controller
       m68knommu: move inclusion of ColdFire v4 cache registers
       m68knommu: clean up ColdFire cache control code
       m68knommu: make cache push code ColdFire generic
       m68knommu: support version 2 ColdFire split cache
       m68knommu: support ColdFire caches that do copyback and write-through
       m68knommu: create optimal separate instruction and data cache for 
ColdFire
       m68knommu: switch to using -mcpu= flags for ColdFire targets
       m68knommu: fix broken setting of irq_chip and handler

Philippe De Muyter (4):
       m68knommu: Create new m54xxacr.h from m5407sim.h subpart
       m68knommu: Move __flush_cache_all definition for m54xx in m54xxacr.h
       m68knommu: Use symbolic constants for cache operations on M54xx
       m68knommu: arch/m68knommu/Kconfig whitespace cleanup

  arch/m68k/include/asm/cacheflush_no.h            |   95 ++++++--------
  arch/m68k/include/asm/coldfire.h                 |    2 +-
  arch/m68k/include/asm/entry_no.h                 |   59 +++++----
  arch/m68k/include/asm/gpio.h                     |    2 +-
  arch/m68k/include/asm/io_no.h                    |    1 -
  arch/m68k/include/asm/m5206sim.h                 |   14 ++-
  arch/m68k/include/asm/m520xsim.h                 |   17 +++-
  arch/m68k/include/asm/m523xsim.h                 |   11 ++
  arch/m68k/include/asm/m5249sim.h                 |   10 ++
  arch/m68k/include/asm/m5272sim.h                 |    8 +
  arch/m68k/include/asm/m527xsim.h                 |   10 ++
  arch/m68k/include/asm/m528xsim.h                 |   11 ++
  arch/m68k/include/asm/m52xxacr.h                 |   94 ++++++++++++++
  arch/m68k/include/asm/m5307sim.h                 |   43 +++----
  arch/m68k/include/asm/m532xsim.h                 |   33 ++----
  arch/m68k/include/asm/m53xxacr.h                 |  101 +++++++++++++++
  arch/m68k/include/asm/m5407sim.h                 |   42 +-----
  arch/m68k/include/asm/m54xxacr.h                 |   97 ++++++++++++++
  arch/m68k/include/asm/{m548xgpt.h => m54xxgpt.h} |   10 +-
  arch/m68k/include/asm/{m548xsim.h => m54xxsim.h} |   23 +++-
  arch/m68k/include/asm/mcfcache.h                 |  150 
----------------------
  arch/m68k/include/asm/mcfsim.h                   |    4 +-
  arch/m68k/include/asm/mcfuart.h                  |   45 +-------
  arch/m68k/include/asm/processor.h                |   13 +-
  arch/m68knommu/Kconfig                           |   98 +++++++++++++--
  arch/m68knommu/Makefile                          |   14 +-
  arch/m68knommu/kernel/setup.c                    |   72 +++--------
  arch/m68knommu/mm/Makefile                       |    2 +-
  arch/m68knommu/mm/fault.c                        |   57 --------
  arch/m68knommu/mm/kmap.c                         |    9 --
  arch/m68knommu/mm/memory.c                       |   33 -----
  arch/m68knommu/platform/{548x => 54xx}/Makefile  |    0
  arch/m68knommu/platform/{548x => 54xx}/config.c  |   32 +++---
  arch/m68knommu/platform/68328/ints.c             |    4 +-
  arch/m68knommu/platform/coldfire/Makefile        |    4 +-
  arch/m68knommu/platform/coldfire/cache.c         |   48 +++++++
  arch/m68knommu/platform/coldfire/entry.S         |   56 ++-------
  arch/m68knommu/platform/coldfire/head.S          |   26 +++-
  38 files changed, 727 insertions(+), 623 deletions(-)
  create mode 100644 arch/m68k/include/asm/m52xxacr.h
  create mode 100644 arch/m68k/include/asm/m53xxacr.h
  create mode 100644 arch/m68k/include/asm/m54xxacr.h
  rename arch/m68k/include/asm/{m548xgpt.h => m54xxgpt.h} (95%)
  rename arch/m68k/include/asm/{m548xsim.h => m54xxsim.h} (73%)
  delete mode 100644 arch/m68k/include/asm/mcfcache.h
  delete mode 100644 arch/m68knommu/mm/fault.c
  delete mode 100644 arch/m68knommu/mm/memory.c
  rename arch/m68knommu/platform/{548x => 54xx}/Makefile (100%)
  rename arch/m68knommu/platform/{548x => 54xx}/config.c (74%)
  create mode 100644 arch/m68knommu/platform/coldfire/cache.c
