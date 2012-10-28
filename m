Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2J1HTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 03:19:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41153 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2J1HTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 03:19:37 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/9] uuid: use random32_get_bytes()
Date: Sun, 28 Oct 2012 16:18:59 +0900
Message-Id: <1351408746-8623-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use random32_get_bytes() to generate 16 bytes of pseudo-random bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/uuid.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/lib/uuid.c b/lib/uuid.c
index 52a6fe6..697f867 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -25,13 +25,7 @@
 
 static void __uuid_gen_common(__u8 b[16])
 {
-	int i;
-	u32 r;
-
-	for (i = 0; i < 4; i++) {
-		r = random32();
-		memcpy(b + i * 4, &r, 4);
-	}
+	random32_get_bytes(b, 16);
 	/* reversion 0b10 */
 	b[8] = (b[8] & 0x3F) | 0x80;
 }
-- 
1.7.11.7

