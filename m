Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2JIX7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:59:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32731 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2JIX6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:58:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make xen happy
Date: Tue,  9 Oct 2012 16:58:28 -0700
Message-Id: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on top of tip/x86/mm2, but please zap last patch in that branch.

1. use brk to mapping first PMD_SIZE range.
2. top down to initialize page table range by range.
3. get rid of calculate page table, and find_early_page_table.
4. remove early_ioremap in page table accessing.

v2: changes, update xen interface about pagetable_reserve, so not
   use pgt_buf_* in xen code directly.
v3: use range top-down to initialize page table, so will not use
   calculating/find early table anymore.
   also reorder the patches sequence.

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

later we could get rid of workaround about xen_mapping_pagetable_reserve, that
could kill another 50 lines codes. --- will do that later because x86/mm2 is
not updated to linus/master yet. If we do that now, will have merge conflicts.

Thanks

Yinghai Lu

Yinghai Lu (7):
  x86, mm: align start address to correct big page size
  x86, mm: Use big page size for small memory range
  x86, mm: Don't clear page table if next range is ram
  x86, mm: only keep initial mapping for ram
  x86, mm: Break down init_all_memory_mapping
  x86, mm: setup page table from top-down
  x86, mm: Remove early_memremap workaround for page table accessing

 arch/x86/include/asm/page_types.h |    1 +
 arch/x86/include/asm/pgtable.h    |    1 +
 arch/x86/kernel/setup.c           |    3 +
 arch/x86/mm/init.c                |  251 ++++++++++++------------------------
 arch/x86/mm/init_32.c             |   18 +++-
 arch/x86/mm/init_64.c             |  100 ++++++---------
 6 files changed, 144 insertions(+), 230 deletions(-)

-- 
1.7.7

