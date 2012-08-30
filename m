Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2H3XGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:06:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37883 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2H3XGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:06:53 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/8] x86, mm: init_memory_mapping cleanup
Date: Thu, 30 Aug 2012 16:06:07 -0700
Message-Id: <1346367975-6446-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <2e8c14cd-b82a-49e6-8d5e-85dbe86da6ca@email.android.com>
References: <2e8c14cd-b82a-49e6-8d5e-85dbe86da6ca@email.android.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only create mapping for E820_820 and E820_RESERVED_KERN.

Also seperate find_early_page_table out with init_memory_mapping.

Jacob Shin (3):
  x86: if kernel .text .data .bss are not marked as E820_RAM, complain
    and fix
  x86: Fixup code testing if a pfn is direct mapped
  x86: Only direct map addresses that are marked as E820_RAM

Yinghai Lu (5):
  x86, mm: Add global page_size_mask
  x86, mm: Split out split_mem_range
  x86, mm: Moving init_memory_mapping calling
  x86, mm: Revert back good_end setting for 64bit
  x86, mm: Find early page table only one time

 arch/x86/include/asm/init.h       |    1 -
 arch/x86/include/asm/page_types.h |    3 +
 arch/x86/include/asm/pgtable.h    |    1 +
 arch/x86/kernel/cpu/amd.c         |    8 +-
 arch/x86/kernel/setup.c           |   34 ++++---
 arch/x86/mm/init.c                |  225 ++++++++++++++++++++++++++-----------
 arch/x86/mm/init_64.c             |    6 +-
 arch/x86/platform/efi/efi.c       |    8 +-
 8 files changed, 191 insertions(+), 95 deletions(-)

-- 
1.7.7

