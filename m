Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2JIEky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:40:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45485 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2JIEkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:40:49 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 07/10] x86, xen, mm: Do not need to check if page table is ioremap
Date: Mon,  8 Oct 2012 21:39:15 -0700
Message-Id: <1349757558-10856-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All page table buf are pre-mapped, and could use _va to access them.

Remove the not needed checking.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/xen/mmu.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 7a769b7..9c0956c 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1412,13 +1412,9 @@ static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
 
 	/*
 	 * If the new pfn is within the range of the newly allocated
-	 * kernel pagetable, and it isn't being mapped into an
-	 * early_ioremap fixmap slot as a freshly allocated page, make sure
-	 * it is RO.
+	 * kernel pagetable, make sure it is RO.
 	 */
-	if (((!is_early_ioremap_ptep(ptep) &&
-			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
-			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
+	if (pfn >= pgt_buf_start && pfn < pgt_buf_top)
 		pte = pte_wrprotect(pte);
 
 	return pte;
-- 
1.7.7

