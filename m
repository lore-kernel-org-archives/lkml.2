Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab2J0Pub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:50:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34043 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab2J0PuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:50:08 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: [PATCH] async_tx: use memchr_inv
Date: Sun, 28 Oct 2012 00:49:33 +0900
Message-Id: <1351352973-3719-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
References: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memchr_inv() to check the specified page is filled with zero.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
---
 crypto/async_tx/async_xor.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 154cc84..8ade0a0 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -230,9 +230,7 @@ EXPORT_SYMBOL_GPL(async_xor);
 
 static int page_is_zero(struct page *p, unsigned int offset, size_t len)
 {
-	char *a = page_address(p) + offset;
-	return ((*(u32 *) a) == 0 &&
-		memcmp(a, a + 4, len - 4) == 0);
+	return !memchr_inv(page_address(p) + offset, 0, len);
 }
 
 static inline struct dma_chan *
-- 
1.7.11.7

