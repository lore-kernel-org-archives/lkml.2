Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2BQNIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:08:40 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56363 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2BQNIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:08:38 -0500
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Jon Medhurst <tixy@yxit.co.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Subject: [PATCH 1/2] ARM: dma-mapping: its array of pointer
Date: Fri, 17 Feb 2012 18:39:30 +0530
Message-Id: <1329484170-26329-1-git-send-email-ajeet.yadav.77@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be consistant with declaration and usage of
consistent_pte it need to be an array of (pte *)

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

