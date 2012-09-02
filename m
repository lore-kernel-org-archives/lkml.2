Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab2IBHra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:47:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40954 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab2IBHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:47:27 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 00/13] x86, mm: init_memory_mapping cleanup
Date: Sun,  2 Sep 2012 00:46:46 -0700
Message-Id: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only create mapping for E820_820 and E820_RESERVED_KERN.

Seperate calculate_table_space_size and find_early_page_table out with
init_memory_mapping.

Also for 64bit, first 1M's page table will be in BRK.

For other range, will allocate page table one time, but init mapping
only for E820 RAM and E820_RESERVED_KERN.

Could be found at:
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

Thanks
	Yinghai

Jacob Shin (4):
  x86: if kernel .text .data .bss are not marked as E820_RAM, complain
    and fix
  x86: Fixup code testing if a pfn is direct mapped
  x86: Only direct map addresses that are marked as E820_RAM
  x86/mm: calculate_table_space_size based on memory ranges that are
    being mapped

Yinghai Lu (9):
  x86, mm: Add global page_size_mask
  x86, mm: Split out split_mem_range
  x86, mm: Moving init_memory_mapping calling
  x86, mm: Revert back good_end setting for 64bit
  x86, mm: Find early page table only one time
  x86, mm: Separate out calculate_table_space_size()
  x86, mm: Move down two calculate_table_space_size down.
  x86, mm: Use func pointer to table size calculation and mapping.
  x86, 64bit: Map first 1M ram early before memblock_x86_fill()

 arch/x86/include/asm/init.h       |    1 -
 arch/x86/include/asm/page_types.h |    3 +
 arch/x86/include/asm/pgtable.h    |    2 +
 arch/x86/kernel/cpu/amd.c         |    8 +-
 arch/x86/kernel/head64.c          |    2 +-
 arch/x86/kernel/setup.c           |   36 ++--
 arch/x86/mm/init.c                |  381 ++++++++++++++++++++++++++-----------
 arch/x86/mm/init_64.c             |   13 +-
 arch/x86/platform/efi/efi.c       |    8 +-
 9 files changed, 315 insertions(+), 139 deletions(-)

-- 
1.7.7

