Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab0J2P4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:56:46 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49669 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab0J2P4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:56:44 -0400
X-IronPort-AV: E=Sophos;i="4.58,260,1286164800"; 
   d="scan'208";a="120276240"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] xen: correct size of level2_kernel_pgt
Date: Fri, 29 Oct 2010 16:56:19 +0100
Message-Id: <1288367779-24001-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 29 Oct 2010 15:56:21.0818 (UTC) FILETIME=[D4FF51A0:01CB7781]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(pmd_t *) is 4 bytes on PAE leading to an allocation of only
2048 bytes. The correct size is sizeof(pmd_t) giving us a full page
allocation.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---

Applies to mainline since 2.6.36 and to xen.git 2.6.32 based trees

 arch/x86/xen/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index c237b81..21ed8d7 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2126,7 +2126,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 {
 	pmd_t *kernel_pmd;
 
-	level2_kernel_pgt = extend_brk(sizeof(pmd_t *) * PTRS_PER_PMD, PAGE_SIZE);
+	level2_kernel_pgt = extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
 
 	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
 				  xen_start_info->nr_pt_frames * PAGE_SIZE +
-- 
1.5.6.5

