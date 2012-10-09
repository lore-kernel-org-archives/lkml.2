Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab2JIEjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:39:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36504 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2JIEjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:39:36 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 00/10] x86: Use BRK to pre mapping page table to make xen happy
Date: Mon,  8 Oct 2012 21:39:08 -0700
Message-Id: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on top of tip/x86/mm2

1. use brk to mapping final page table
2. remove early_ioremap in page table accessing.

v1-v2: changes, update xen interface about pagetable_reserve, so not
   use pgt_buf_* in xen code directly.

could be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

Yinghai Lu (10):
  x86, mm: align start address to correct big page size
  x86, mm: Use big page size for small memory range
  x86, mm: get early page table from BRK
  x86, mm: Don't clear page table if next range is ram
  x86, mm: Remove early_memremap workaround for page table accessing
  x86, mm: only keep initial mapping for ram
  x86, xen, mm: Do not need to check if page table is ioremap
  x86, xen, mm: fix mapping_pagetable_reserve logic
  x86, mm: Hide pgt_buf_* into internal to xen
  x86, mm: Add early_pgt_buf_*

 arch/x86/include/asm/init.h          |    5 ++
 arch/x86/include/asm/pgtable.h       |    1 +
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/include/asm/x86_init.h      |    2 +-
 arch/x86/kernel/setup.c              |    2 +
 arch/x86/kernel/x86_init.c           |    3 +-
 arch/x86/mm/init.c                   |   73 ++++++++++++++++++++++++---
 arch/x86/mm/init_32.c                |    9 +++-
 arch/x86/mm/init_64.c                |   91 ++++++++++++----------------------
 arch/x86/xen/mmu.c                   |   26 +++------
 10 files changed, 125 insertions(+), 88 deletions(-)

-- 
1.7.7

