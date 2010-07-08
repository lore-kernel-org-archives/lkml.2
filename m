Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0GHHAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:00:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:43054 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab0GHHAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:00:04 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       linux-arch@vger.kernel.org
Subject: [PATCH -mm 0/3] unify dma_get_cache_alignment implementations
Date: Thu,  8 Jul 2010 15:57:45 +0900
Message-Id: <1278572268-26146-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 08 Jul 2010 15:59:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now each architecture has the own dma_get_cache_alignment
implementation.

dma_get_cache_alignment returns the minimum DMA
alignment. Architectures defines it as ARCH_KMALLOC_MINALIGN (it's
used to make sure that malloc'ed buffer is DMA-safe; the buffer
doesn't share a cache with the others). So we can unify
dma_get_cache_alignment implementations.

This can be applied to -mm.

=
 arch/alpha/include/asm/dma-mapping.h         |    1 -
 arch/arm/include/asm/cache.h                 |    2 +-
 arch/arm/include/asm/dma-mapping.h           |    5 -----
 arch/avr32/include/asm/cache.h               |    2 +-
 arch/avr32/include/asm/dma-mapping.h         |    5 -----
 arch/blackfin/include/asm/cache.h            |    2 +-
 arch/blackfin/include/asm/dma-mapping.h      |    1 -
 arch/cris/include/asm/dma-mapping.h          |    6 ------
 arch/frv/include/asm/dma-mapping.h           |    6 ------
 arch/frv/include/asm/mem-layout.h            |    2 +-
 arch/ia64/include/asm/dma-mapping.h          |    2 --
 arch/ia64/kernel/setup.c                     |    6 ------
 arch/m68k/include/asm/cache.h                |    2 +-
 arch/m68k/include/asm/dma-mapping.h          |    5 -----
 arch/microblaze/include/asm/dma-mapping.h    |    5 -----
 arch/microblaze/include/asm/page.h           |    2 +-
 arch/mips/include/asm/dma-mapping.h          |    7 -------
 arch/mips/include/asm/mach-generic/kmalloc.h |    2 +-
 arch/mips/include/asm/mach-ip27/kmalloc.h    |    2 +-
 arch/mips/include/asm/mach-ip32/kmalloc.h    |    4 ++--
 arch/mips/include/asm/mach-tx49xx/kmalloc.h  |    2 +-
 arch/mn10300/include/asm/cache.h             |    2 +-
 arch/mn10300/include/asm/dma-mapping.h       |    6 ------
 arch/parisc/include/asm/cache.h              |    2 ++
 arch/parisc/include/asm/dma-mapping.h        |    6 ------
 arch/powerpc/include/asm/dma-mapping.h       |   15 ---------------
 arch/powerpc/include/asm/page_32.h           |    2 +-
 arch/sh/include/asm/dma-mapping.h            |    9 ---------
 arch/sh/include/asm/page.h                   |    2 +-
 arch/sparc/include/asm/dma-mapping.h         |    9 ---------
 arch/tile/include/asm/dma-mapping.h          |    7 -------
 arch/x86/include/asm/dma-mapping.h           |    7 -------
 arch/xtensa/include/asm/cache.h              |    2 +-
 arch/xtensa/include/asm/dma-mapping.h        |    6 ------
 include/linux/dma-mapping.h                  |    8 ++++++++
 include/linux/slab_def.h                     |    4 +++-
 include/linux/slob_def.h                     |    4 +++-
 include/linux/slub_def.h                     |    8 +++++---
 38 files changed, 36 insertions(+), 134 deletions(-)
