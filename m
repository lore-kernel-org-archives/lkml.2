Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2AKIPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:15:08 -0500
Received: from mail1.windriver.com ([147.11.146.13]:60703 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab2AKIPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:15:06 -0500
X-Greylist: delayed 8625 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jan 2012 03:15:06 EST
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] kmemleak: only scan non-zero-size section
Date: Wed, 11 Jan 2012 13:51:10 +0800
Message-ID: <1326261070-24427-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should only scan that invalid section which size is not
zero as well.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
change for v2
 * go a common point, kmemleak_scan_area(), to check size

 mm/kmemleak.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2c0d032..98d62e3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -923,7 +923,7 @@ void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+	if (atomic_read(&kmemleak_enabled) && ptr && size && !IS_ERR(ptr))
 		add_scan_area((unsigned long)ptr, size, gfp);
 	else if (atomic_read(&kmemleak_early_log))
 		log_early(KMEMLEAK_SCAN_AREA, ptr, size, 0);
-- 
1.6.0.4

