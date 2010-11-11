Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0KKPOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:14:45 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54624 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753659Ab0KKPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:14:43 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LBQ7NL-01-MAC-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <greg@kroah.com>
CC: Borislav Petkov <bp@amd64.org>, <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>, Hugh Dickins <hughd@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
Date: Thu, 11 Nov 2010 16:16:15 +0100
Message-ID: <1289488576-18117-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20101111141358.GA4641@kroah.com>
References: <20101111141358.GA4641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit b7d460897739e02f186425b7276e3fdb1595cea7 upstream

rc2 kernel crashes when booting second cpu on this CONFIG_VMSPLIT_2G_OPT
laptop: whereas cloning from kernel to low mappings pgd range does need
to limit by both KERNEL_PGD_PTRS and KERNEL_PGD_BOUNDARY, cloning kernel
pgd range itself must not be limited by the smaller KERNEL_PGD_BOUNDARY.

Signed-off-by: Hugh Dickins <hughd@google.com>
LKML-Reference: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/trampoline.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index 4e816a4..0ac23a7 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -47,8 +47,7 @@ void __init setup_trampoline_page_table(void)
 	/* Copy kernel address range */
 	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
 			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			min_t(unsigned long, KERNEL_PGD_PTRS,
-			      KERNEL_PGD_BOUNDARY));
+			KERNEL_PGD_PTRS);
 
 	/* Initialize low mappings */
 	clone_pgd_range(trampoline_pg_dir,
-- 
1.7.0.4


