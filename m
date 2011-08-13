Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1HMM7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 08:59:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35346 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1HMM7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 08:59:21 -0400
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH] Fix non-LPAE boot regression.
Date: Sat, 13 Aug 2011 15:58:19 +0300
Message-Id: <1313240299-24712-1-git-send-email-anarsoul@gmail.com>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <201108131556.27301.anarsoul@gmail.com>
References: <201108131556.27301.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was introduced by  407f8b4cb07cbc5c1c7cc386f231224e2524ccea
ARM: LPAE: MMU setup for the 3-level page table format

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 arch/arm/kernel/head.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 0bdafc4..5add5f5 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -206,7 +206,7 @@ __create_page_tables:
 1:	orr	r3, r7, r5, lsl #SECTION_SHIFT	@ flags + kernel base
 	str	r3, [r4, r5, lsl #PMD_ORDER]	@ identity mapping
 	cmp	r5, r6
-	addlo	r5, r5, #SECTION_SHIFT >> 20	@ next section
+	addlo	r5, r5, #1			@ next section
 	blo	1b
 
 	/*
@@ -217,7 +217,7 @@ __create_page_tables:
 	mov	r3, r3, lsr #SECTION_SHIFT
 	orr	r3, r7, r3, lsl #SECTION_SHIFT
 	add	r0, r4,  #(KERNEL_START & 0xff000000) >> (SECTION_SHIFT - PMD_ORDER)
-	str	r3, [r0, #(KERNEL_START & 0x00e00000) >> (SECTION_SHIFT - PMD_ORDER)]!
+	str	r3, [r0, #(KERNEL_START & 0x00f00000) >> (SECTION_SHIFT - PMD_ORDER)]!
 	ldr	r6, =(KERNEL_END - 1)
 	add	r0, r0, #1 << PMD_ORDER
 	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ORDER)
-- 
1.7.5.rc3

