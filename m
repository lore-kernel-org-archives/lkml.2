Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1HVQ1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:27:34 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:62531 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1HVQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:27:28 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/4] debug-pagealloc: use memchr_inv
Date: Tue, 23 Aug 2011 01:29:08 +0900
Message-Id: <1314030548-21082-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use newly introduced memchr_inv for page verification.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/debug-pagealloc.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/debug-pagealloc.c b/mm/debug-pagealloc.c
index 5afe80c..d8470d4 100644
--- a/mm/debug-pagealloc.c
+++ b/mm/debug-pagealloc.c
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/page-debug-flags.h>
@@ -62,11 +63,8 @@ static void check_poison_mem(unsigned char *mem, size_t bytes)
 	unsigned char *start;
 	unsigned char *end;
 
-	for (start = mem; start < mem + bytes; start++) {
-		if (*start != PAGE_POISON)
-			break;
-	}
-	if (start == mem + bytes)
+	start = memchr_inv(mem, PAGE_POISON, bytes);
+	if (!start)
 		return;
 
 	for (end = mem + bytes - 1; end > start; end--) {
-- 
1.7.4.4

