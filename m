Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3ACM0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:26:36 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46284 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab3ACMTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:19:43 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 02/26] uuid: use prandom_bytes()
Date: Thu,  3 Jan 2013 21:18:58 +0900
Message-Id: <1357215562-6288-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use prandom_bytes() to generate 16 bytes of pseudo-random bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Huang Ying <ying.huang@intel.com>
---

No change from v1

 lib/uuid.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/lib/uuid.c b/lib/uuid.c
index 52a6fe6..398821e 100644
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
+	prandom_bytes(b, 16);
 	/* reversion 0b10 */
 	b[8] = (b[8] & 0x3F) | 0x80;
 }
-- 
1.7.11.7

