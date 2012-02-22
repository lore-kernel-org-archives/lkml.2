Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2BVDf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:35:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55578 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2BVDfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:35:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ajeet.yadav.77@gmail.com designates 10.68.136.201 as permitted sender) smtp.mail=ajeet.yadav.77@gmail.com; dkim=pass header.i=ajeet.yadav.77@gmail.com
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Jon Medhurst <tixy@yxit.co.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Subject: [PATCH] ARM: dma-mapping: Fix the type used for consistent_pte size calculation
Date: Wed, 22 Feb 2012 09:06:55 +0530
Message-Id: <1329881815-11306-1-git-send-email-ajeet.yadav.77@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be consistent with declaration and usage of consistent_pte, it needs
to be an array of (pte *)

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 arch/arm/mm/dma-mapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 1aa664a..04bfa76 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -170,7 +170,7 @@ static int __init consistent_init(void)
 	unsigned long base = consistent_base;
 	unsigned long num_ptes = (CONSISTENT_END - base) >> PMD_SHIFT;
 
-	consistent_pte = kmalloc(num_ptes * sizeof(pte_t), GFP_KERNEL);
+	consistent_pte = kmalloc(num_ptes * sizeof(pte_t *), GFP_KERNEL);
 	if (!consistent_pte) {
 		pr_err("%s: no memory\n", __func__);
 		return -ENOMEM;
-- 
1.7.8.4

