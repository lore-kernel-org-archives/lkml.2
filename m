Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2BTQHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:07:39 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19462 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2BTQHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:07:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org
Cc: jeremy@goop.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/setup: Remove redundant filtering of PTE masks.
Date: Mon, 20 Feb 2012 11:01:26 -0500
Message-Id: <1329753687-29218-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1329753687-29218-1-git-send-email-konrad.wilk@oracle.com>
References: <1329753687-29218-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090207.4F426FB4.0010,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7347b4082e55ac4a673f06a0a0ce25c37273c9ec "xen: Allow
unprivileged Xen domains to create iomap pages" added a redundant
line in the early bootup code to filter out the PTE. That
filtering is already done a bit earlier so this extra processing
is not required.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 12eb07b..7c44e1b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1204,10 +1204,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
-	if (!xen_initial_domain())
-		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
-
-	__supported_pte_mask |= _PAGE_IOMAP;
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
-- 
1.7.9.48.g85da4d

