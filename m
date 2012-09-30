Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab2I3H5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:57:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20384 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2I3H5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:57:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v4 00/13] x86, mm: init_memory_mapping cleanup
Date: Sun, 30 Sep 2012 00:57:11 -0700
Message-Id: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernel init memory mapping between [0, TOML) and [4G, TOMH)
Some AMD systems have mem hole between 4G and TOMH, around 1T.

According to HPA, we should only mapping ram range.

This patcheset:
1. Seperate calculate_table_space_size and find_early_page_table out with
   init_memory_mapping.

2. For all ranges, will allocate page table one time

3. init mapping for ram range one by one.

Could be found at:
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

Jacob Shin (4):
  x86: if kernel .text .data .bss are not marked as E820_RAM, complain and fix
  x86: Fixup code testing if a pfn is direct mapped
  x86: Only direct map addresses that are marked as E820_RAM
  x86/mm: calculate_table_space_size based on memory ranges that are being mapped

Yinghai Lu (9):
  x86, mm: Add global page_size_mask and probe one time only
  x86, mm: Split out split_mem_range from init_memory_mapping
  x86, mm: Move init_memory_mapping calling out of setup.c
  x86, mm: Revert back good_end setting for 64bit
  x86, mm: Find early page table buffer altogether
  x86, mm: Separate out calculate_table_space_size()
  x86, mm: Move down two calculate_table_space_size down.
  x86, mm: Set memblock initial limit to 1M
  x86, mm: Use func pointer to table size calculation and mapping

 arch/x86/include/asm/init.h       |    1 -
 arch/x86/include/asm/page_types.h |    2 +
 arch/x86/include/asm/pgtable.h    |    1 +
 arch/x86/kernel/cpu/amd.c         |    8 +-
 arch/x86/kernel/setup.c           |   36 +++--
 arch/x86/mm/init.c                |  350 +++++++++++++++++++++++++------------
 arch/x86/mm/init_64.c             |    6 +-
 arch/x86/platform/efi/efi.c       |    8 +-
 8 files changed, 273 insertions(+), 139 deletions(-)

-- 
1.7.7

