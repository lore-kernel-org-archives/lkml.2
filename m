Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1EBRWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:22:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62258 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1EBRWn (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 2 May 2011 13:22:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        yinghai@kernel.org, hpa@zytor.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen: mask_rw_pte mark RO all pagetable pages up to pgt_buf_top
Date: Mon,  2 May 2011 13:22:22 -0400
Message-Id: <1304356942-17656-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DBEE85D.00BC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

mask_rw_pte is currently checking if a pfn is a pagetable page if it
falls in the range pgt_buf_start - pgt_buf_end but that is incorrect
because pgt_buf_end is a moving target: pgt_buf_top is the real
boundary.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 1bca25f..55c965b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1616,7 +1616,7 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 	 * it is RO.
 	 */
 	if (((!is_early_ioremap_ptep(ptep) &&
-			pfn >= pgt_buf_start && pfn < pgt_buf_end)) ||
+			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
 			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
 		pte = pte_wrprotect(pte);
 
-- 
1.7.1

