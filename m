Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2KMNks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:40:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab2KMNhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:37:43 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Subject: [PATCH v3 05/11] ubifs: use prandom_bytes
Date: Tue, 13 Nov 2012 22:37:04 +0900
Message-Id: <1352813830-4624-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352813830-4624-1-git-send-email-akinobu.mita@gmail.com>
References: <1352813830-4624-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also converts filling memory loop to use memset.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-mtd@lists.infradead.org
---
* v3
- rename random32_get_bytes to prandom_bytes

 fs/ubifs/debug.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 6291163..12817ff 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2560,7 +2560,7 @@ static int power_cut_emulated(struct ubifs_info *c, int lnum, int write)
 static int corrupt_data(const struct ubifs_info *c, const void *buf,
 			unsigned int len)
 {
-	unsigned int from, to, i, ffs = chance(1, 2);
+	unsigned int from, to, ffs = chance(1, 2);
 	unsigned char *p = (void *)buf;
 
 	from = random32() % (len + 1);
@@ -2571,11 +2571,9 @@ static int corrupt_data(const struct ubifs_info *c, const void *buf,
 		   ffs ? "0xFFs" : "random data");
 
 	if (ffs)
-		for (i = from; i < to; i++)
-			p[i] = 0xFF;
+		memset(p + from, 0xFF, to - from);
 	else
-		for (i = from; i < to; i++)
-			p[i] = random32() % 0x100;
+		prandom_bytes(p + from, to - from);
 
 	return to;
 }
-- 
1.7.11.7

