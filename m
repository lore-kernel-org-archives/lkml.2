Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab2DAUjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:39:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:54103 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2DAUi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:38:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 00/11] Fix up more asm/system.h fallout
Date: Sun,  1 Apr 2012 16:38:36 -0400
Message-Id: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like others, I was surprised it didn't get a soak in linux-next
before being merged, but I guess what is done is done, so lets
try and limit the fallout from having any wider of a commit range
than it already does.

It is all system.h stuff except for three things.

 1) an avr32 patch I'd created but the avr32 guys hadn't got
    signed keys yet, so I might as well get it in here along
    with other similar build fail fixes (the atmel one).

 2) A cosmetic fix to the device.h changeset from me earlier.

 3) A trivial warning fix to an arch/frv specific file.

I'm going to queue this up in my feed branch to linux-next
so we can start reducing the number of build failures from what
we had on Friday.

Paul.
---

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git buildfixes

for you to fetch changes up to af901116760f93297ad53cc3a0cc5e370e9ccb5a:

  asm-generic: add linux/types.h to cmpxchg.h (2012-04-01 15:59:54 -0400)

----------------------------------------------------------------

Paul Gortmaker (11):
  irq_work: fix compile failure on MIPS from system.h split
  ARM: mach-msm: fix compile fail from system.h fallout
  avr32: fix nop compile fails from system.h split up
  avr32: fix build failures from mis-naming of atmel_nand.h
  blackfin: fix cmpxchg build fails from system.h fallout
  parisc: fix missing cmpxchg file error from system.h split
  sh: fix several build failures from system.h fallout
  frv: fix warnings in mb93090-mb00/pci-dma.c about implicit EXPORT_SYMBOL
  firewire: restore the device.h include in linux/firewire.h
  tile: fix multiple build failures from system.h dismantle
  asm-generic: add linux/types.h to cmpxchg.h

 arch/arm/mach-msm/include/mach/uncompress.h |    1 +
 arch/avr32/include/asm/mmu_context.h        |    1 +
 arch/avr32/mach-at32ap/include/mach/board.h |    2 +-
 arch/blackfin/include/asm/cmpxchg.h         |    3 +-
 arch/frv/mb93090-mb00/pci-dma.c             |    1 +
 arch/parisc/include/asm/atomic.h            |  107 +------------------------
 arch/parisc/include/asm/cmpxchg.h           |  116 +++++++++++++++++++++++++++
 arch/sh/kernel/cpu/fpu.c                    |    1 +
 arch/sh/kernel/cpu/sh4/fpu.c                |    1 +
 arch/sh/mm/cache-sh4.c                      |    1 +
 arch/sh/mm/flush-sh4.c                      |    1 +
 arch/tile/include/asm/atomic.h              |   50 +-----------
 arch/tile/include/asm/cmpxchg.h             |   73 +++++++++++++++++
 arch/tile/kernel/process.c                  |    1 +
 arch/tile/kernel/stack.c                    |    1 +
 include/asm-generic/cmpxchg.h               |    1 +
 include/linux/firewire.h                    |    3 +-
 include/linux/platform_data/atmel.h         |    6 +-
 kernel/irq_work.c                           |    1 +
 19 files changed, 210 insertions(+), 161 deletions(-)
 create mode 100644 arch/parisc/include/asm/cmpxchg.h
 create mode 100644 arch/tile/include/asm/cmpxchg.h

-- 
1.7.9.1

