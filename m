Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2JIEkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:40:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45368 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2JIEkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:40:32 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/10] x86, mm: only keep initial mapping for ram
Date: Mon,  8 Oct 2012 21:39:14 -0700
Message-Id: <1349757558-10856-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0 mean any e820 type will be kept, and only hole is removed.

change to E820_RAM and E820_RESERVED_KERN only.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4b21950..aab1fc1 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -349,7 +349,8 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 		next = (addr & PAGE_MASK) + PAGE_SIZE;
 		if (addr >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(addr & PAGE_MASK, next, 0))
+			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RAM) &&
+			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RESERVED_KERN))
 				set_pte(pte, __pte(0));
 			continue;
 		}
@@ -396,7 +397,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		next = (address & PMD_MASK) + PMD_SIZE;
 		if (address >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(address & PMD_MASK, next, 0))
+			    !e820_any_mapped(address & PMD_MASK, next, E820_RAM) &&
+			    !e820_any_mapped(address & PMD_MASK, next, E820_RESERVED_KERN))
 				set_pmd(pmd, __pmd(0));
 			continue;
 		}
@@ -468,7 +470,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		next = (addr & PUD_MASK) + PUD_SIZE;
 		if (addr >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(addr & PUD_MASK, next, 0))
+			    !e820_any_mapped(addr & PUD_MASK, next, E820_RAM) &&
+			    !e820_any_mapped(addr & PUD_MASK, next, E820_RESERVED_KERN))
 				set_pud(pud, __pud(0));
 			continue;
 		}
-- 
1.7.7

