Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab2HPQWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:22:35 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49931 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab2HPQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:22:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/6] xen/mmu: Fix compile warnings.
Date: Thu, 16 Aug 2012 12:12:36 -0400
Message-Id: <1345133558-23341-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
References: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/arch/x86/xen/mmu.c:1788:14: warning: comparison between pointer and integer [enabled by default]

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 90d31a2..4911354 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1786,11 +1786,11 @@ void __init xen_setup_machphys_mapping(void)
 {
 	struct xen_machphys_mapping mapping;
 
-	if (HYPERVISOR_memory_op(XENMEM_machphys_mapping, &mapping) == 0) {
+	if (HYPERVISOR_memory_op(XENMEM_machphys_mapping, (void *)&mapping) == 0) {
 		machine_to_phys_mapping = (unsigned long *)mapping.v_start;
 		machine_to_phys_nr = mapping.max_mfn + 1;
 	} else {
-		machine_to_phys_nr = MACH2PHYS_NR_ENTRIES;
+		machine_to_phys_nr = (unsigned long)MACH2PHYS_NR_ENTRIES;
 	}
 #ifdef CONFIG_X86_32
 	WARN_ON((machine_to_phys_mapping + (machine_to_phys_nr - 1))
-- 
1.7.7.6

