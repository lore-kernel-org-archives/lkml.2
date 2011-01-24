Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1AXR4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:56:22 -0500
Received: from service87.mimecast.com ([94.185.240.25]:50824 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753897Ab1AXR4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:56:20 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/19] ARM: LPAE: Fix early_pte_alloc() assumption about the Linux PTE
Date: Mon, 24 Jan 2011 17:55:44 +0000
Message-Id: <1295891761-18366-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c.dirty
In-Reply-To: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 Jan 2011 17:56:10.0585 (UTC) FILETIME=[FBC65C90:01CBBBEF]
X-MC-Unique: 111012417561500501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0OI0EVk031625

With LPAE we no longer have software bits in a separate Linux PTE and
the early_pte_alloc() function should pass PTE_HWTABLE_OFF +
PTE_HWTABLE_SIZE to early_alloc() to avoid allocating extra memory.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 3c67e92..dcafa5c 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -533,7 +533,7 @@ static void __init *early_alloc(unsigned long sz)
 static pte_t * __init early_pte_alloc(pmd_t *pmd, unsigned long addr, unsigned long prot)
 {
 	if (pmd_none(*pmd)) {
-		pte_t *pte = early_alloc(2 * PTRS_PER_PTE * sizeof(pte_t));
+		pte_t *pte = early_alloc(PTE_HWTABLE_OFF + PTE_HWTABLE_SIZE);
 		__pmd_populate(pmd, __pa(pte), prot);
 	}
 	BUG_ON(pmd_bad(*pmd));

