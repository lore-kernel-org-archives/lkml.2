Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2DPSqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:46:16 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36985 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2DPSqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:46:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: xen-devel@lists.xensource.com, suresh.b.siddha@intel.com, hpa@zytor.com,
        hpa@zytor.co, tglx@linutronix.de,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] Revert "xen/x86: Workaround 'x86/ioapic: Add register level checks to detect bogus io-apic entries'"
Date: Mon, 16 Apr 2012 14:40:16 -0400
Message-Id: <1334601616-25309-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1334601616-25309-1-git-send-email-konrad.wilk@oracle.com>
References: <1334601616-25309-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F8C68E8.0060,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 2531d64b6fe2724dc432b67d8dc66bd45621da0b.

The two patches:
      x86/apic: Replace io_apic_ops with x86_io_apic_ops.
      xen/x86: Implement x86_apic_ops

take care of fixing it properly.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b8e2794..988828b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1859,7 +1859,6 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 #endif	/* CONFIG_X86_64 */
 
 static unsigned char dummy_mapping[PAGE_SIZE] __page_aligned_bss;
-static unsigned char fake_ioapic_mapping[PAGE_SIZE] __page_aligned_bss;
 
 static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 {
@@ -1900,7 +1899,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 		 * We just don't map the IO APIC - all access is via
 		 * hypercalls.  Keep the address in the pte for reference.
 		 */
-		pte = pfn_pte(PFN_DOWN(__pa(fake_ioapic_mapping)), PAGE_KERNEL);
+		pte = pfn_pte(PFN_DOWN(__pa(dummy_mapping)), PAGE_KERNEL);
 		break;
 #endif
 
@@ -2065,7 +2064,6 @@ void __init xen_init_mmu_ops(void)
 	pv_mmu_ops = xen_mmu_ops;
 
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
-	memset(fake_ioapic_mapping, 0xfd, PAGE_SIZE);
 }
 
 /* Protected by xen_reservation_lock. */
-- 
1.7.7.5

