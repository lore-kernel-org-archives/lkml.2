Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3ACMTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:19:46 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57191 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3ACMTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:19:42 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH -v2 01/26] raid6test: use prandom_bytes()
Date: Thu,  3 Jan 2013 21:18:57 +0900
Message-Id: <1357215562-6288-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use prandom_bytes() to generate random bytes for test data.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>
---

No change from v1

 crypto/async_tx/raid6test.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index aa2b027..4a92bac 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -46,15 +46,10 @@ static void callback(void *param)
 
 static void makedata(int disks)
 {
-	int i, j;
+	int i;
 
 	for (i = 0; i < disks; i++) {
-		for (j = 0; j < PAGE_SIZE/sizeof(u32); j += sizeof(u32)) {
-			u32 *p = page_address(data[i]) + j;
-
-			*p = random32();
-		}
-
+		prandom_bytes(page_address(data[i]), PAGE_SIZE);
 		dataptrs[i] = data[i];
 	}
 }
-- 
1.7.11.7

