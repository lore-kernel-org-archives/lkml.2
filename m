Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab0KSBkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:40:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10718 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0KSBkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:40:35 -0500
Date: Fri, 19 Nov 2010 10:40:29 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] ARM: l2x0: Check the correct address range
To: linux-arm-kernel@lists.infradead.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>
Message-id: <20101119014029.GA26429@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 19 Nov 2010 01:40:32.0739 (UTC)
 FILETIME=[C13C6B30:01CB878A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boojin Kim <boojin.kim@samsung.com>

When flush or clean the 1MiB, it doesn't flush or clean all since it doesn't check the correct address. So Check the correct address range.

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 170c9bb..50599d9 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -195,7 +195,7 @@ static void l2x0_clean_range(unsigned long start, unsigned long end)
 	void __iomem *base = l2x0_base;
 	unsigned long flags;
 
-	if ((end - start) >= l2x0_size) {
+	if ((end - start + 1) >= l2x0_size) {
 		l2x0_clean_all();
 		return;
 	}
@@ -225,7 +225,7 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
 	void __iomem *base = l2x0_base;
 	unsigned long flags;
 
-	if ((end - start) >= l2x0_size) {
+	if ((end - start + 1) >= l2x0_size) {
 		l2x0_flush_all();
 		return;
 	}
