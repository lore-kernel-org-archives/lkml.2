Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab0GVSqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:46:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62834 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554Ab0GVSqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:46:08 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v26 00/16] Use memblock with x86
Date: Thu, 22 Jul 2010 11:43:45 -0700
Message-Id: <1279824241-17582-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C4891C3.018B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New memblock could be used to replace early_res in x86.

Suggested by: David, Ben, and Thomas

-v25: update to mainline with kmemleak fix on nobootmem
      also rename lmb to memblock alread in mainline

-v26: according to Linus and hpa, seperate the big patchset to small ones.

this one is x86 related, finally we can remove bootmem code in x86 and early_res code.

Thanks

Yinghai Lu

[PATCH 01/16] x86, memblock: Add memblock_x86_find_in_range_size()
[PATCH 02/16] bootmem, x86: Add weak version of reserve_bootmem_generic
[PATCH 03/16] x86, memblock: Add memblock_x86_to_bootmem()
[PATCH 04/16] x86,memblock: Add memblock_x86_reserve_range/memblock_x86_free_range
[PATCH 05/16] x86, memblock: Add get_free_all_memory_range()
[PATCH 06/16] x86, memblock: Add memblock_x86_register_active_regions() and memblock_x86_hole_size()
[PATCH 07/16] memblock: Add find_memory_core_early()
[PATCH 08/16] x86, memblock: Add memblock_x86_find_in_range_node()
[PATCH 09/16] x86, memblock: Add memblock_x86_free_memory_in_range()
[PATCH 10/16] x86, memblock: Add memblock_x86_memory_in_range()
[PATCH 11/16] x86, memblock: Use memblock_debug to control debug message print out
[PATCH 12/16] x86: Use memblock to replace early_res
[PATCH 13/16] x86: Replace e820_/_early string with memblock_
[PATCH 14/16] x86: Remove not used early_res code
[PATCH 15/16] x86, memblock: Use memblock_memory_size()/memblock_free_memory_size() to get correct dma_reserve
[PATCH 16/16] x86: remove old bootmem code

 arch/x86/Kconfig                |   15 +-
 arch/x86/include/asm/e820.h     |   20 +-
 arch/x86/include/asm/efi.h      |    2 +-
 arch/x86/include/asm/memblock.h |   21 ++
 arch/x86/kernel/acpi/sleep.c    |    7 +-
 arch/x86/kernel/apic/numaq_32.c |    3 +-
 arch/x86/kernel/check.c         |   16 +-
 arch/x86/kernel/e820.c          |  192 ++++---------
 arch/x86/kernel/efi.c           |    5 +-
 arch/x86/kernel/head.c          |    3 +-
 arch/x86/kernel/head32.c        |   10 +-
 arch/x86/kernel/head64.c        |    7 +-
 arch/x86/kernel/mpparse.c       |    5 +-
 arch/x86/kernel/setup.c         |   78 +++--
 arch/x86/kernel/setup_percpu.c  |    6 -
 arch/x86/kernel/trampoline.c    |    8 +-
 arch/x86/mm/Makefile            |    2 +
 arch/x86/mm/init.c              |    7 +-
 arch/x86/mm/init_32.c           |   66 +-----
 arch/x86/mm/init_64.c           |   67 +-----
 arch/x86/mm/k8topology_64.c     |    4 +-
 arch/x86/mm/memblock.c          |  359 ++++++++++++++++++++++++
 arch/x86/mm/memtest.c           |    7 +-
 arch/x86/mm/numa_32.c           |   28 +-
 arch/x86/mm/numa_64.c           |   84 ++-----
 arch/x86/mm/srat_32.c           |    3 +-
 arch/x86/mm/srat_64.c           |   11 +-
 arch/x86/xen/mmu.c              |    5 +-
 arch/x86/xen/setup.c            |    3 +-
 include/linux/early_res.h       |   23 --
 include/linux/mm.h              |    2 +
 kernel/Makefile                 |    1 -
 kernel/early_res.c              |  590 ---------------------------------------
 mm/bootmem.c                    |   13 +-
 mm/page_alloc.c                 |   86 ++++---
 mm/sparse-vmemmap.c             |   11 -
 36 files changed, 651 insertions(+), 1119 deletions(-)
 create mode 100644 arch/x86/include/asm/memblock.h
 create mode 100644 arch/x86/mm/memblock.c
 delete mode 100644 include/linux/early_res.h
 delete mode 100644 kernel/early_res.c
