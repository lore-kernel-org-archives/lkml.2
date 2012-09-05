Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2IEFrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:47:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20438 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2IEFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:47:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 00/14] x86, mm: init_memory_mapping cleanup
Date: Tue,  4 Sep 2012 22:46:17 -0700
Message-Id: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only create mapping for E820_820 and E820_RESERVED_KERN.

Seperate calculate_table_space_size and find_early_page_table out with
init_memory_mapping.

For all ranges, will allocate page table one time, but init mapping
only for E820 RAM and E820_RESERVED_KERN.

Could be found at:
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

Thanks
        Yinghai


Jacob Shin (4):
  x86: if kernel .text .data .bss are not marked as E820_RAM, complain and fix
  x86: Fixup code testing if a pfn is direct mapped
  x86: Only direct map addresses that are marked as E820_RAM
  x86/mm: calculate_table_space_size based on memory ranges that are being mapped

Yinghai Lu (10):
  x86, mm: Add global page_size_mask
  x86, mm: Split out split_mem_range
  x86, mm: Moving init_memory_mapping calling
  x86, mm: Revert back good_end setting for 64bit
  x86, mm: Find early page table only one time
  x86, mm: Separate out calculate_table_space_size()
  x86, mm: Move down two calculate_table_space_size down.
  x86, mm: set memblock initial limit to 1M
  x86, mm: Use func pointer to table size calculation and mapping
  x86, mm: Map ISA area with connected ram range at the same time

 arch/x86/include/asm/init.h       |    1 -
 arch/x86/include/asm/page_types.h |    2 +
 arch/x86/include/asm/pgtable.h    |    1 +
 arch/x86/kernel/cpu/amd.c         |    8 +-
 arch/x86/kernel/setup.c           |   36 +++--
 arch/x86/mm/init.c                |  357 +++++++++++++++++++++++++------------
 arch/x86/mm/init_64.c             |    6 +-
 arch/x86/platform/efi/efi.c       |    8 +-
 8 files changed, 280 insertions(+), 139 deletions(-)

-- 
1.7.7

