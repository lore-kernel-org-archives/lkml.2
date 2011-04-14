Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902Ab1DNSVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:21:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:41383 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650Ab1DNR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Hugh Dickins <hughd@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 121/209] x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
Date: Thu, 14 Apr 2011 13:54:39 -0400
Message-Id: <1302803767-9715-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit b7d460897739e02f186425b7276e3fdb1595cea7 upstream.

rc2 kernel crashes when booting second cpu on this CONFIG_VMSPLIT_2G_OPT
laptop: whereas cloning from kernel to low mappings pgd range does need
to limit by both KERNEL_PGD_PTRS and KERNEL_PGD_BOUNDARY, cloning kernel
pgd range itself must not be limited by the smaller KERNEL_PGD_BOUNDARY.

Signed-off-by: Hugh Dickins <hughd@google.com>
LKML-Reference: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/trampoline.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index a874495..e2a5952 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -45,8 +45,7 @@ void __init setup_trampoline_page_table(void)
 	/* Copy kernel address range */
 	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
 			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			min_t(unsigned long, KERNEL_PGD_PTRS,
-			      KERNEL_PGD_BOUNDARY));
+			KERNEL_PGD_PTRS);
 
 	/* Initialize low mappings */
 	clone_pgd_range(trampoline_pg_dir,
-- 
1.7.4.4

