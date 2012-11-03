Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2KCPqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 11:46:16 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48484 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab2KCPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 11:44:27 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Subject: [PATCH v2 05/11] ubifs: use random32_get_bytes
Date: Sun,  4 Nov 2012 00:43:36 +0900
Message-Id: <1351957422-23243-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351957422-23243-1-git-send-email-akinobu.mita@gmail.com>
References: <1351957422-23243-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also converts filling memory loop to use memset.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-mtd@lists.infradead.org
---
no change from v1

 fs/ubifs/debug.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 6291163..f3e4a25 100644
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
+		random32_get_bytes(p + from, to - from);
 
 	return to;
 }
-- 
1.7.11.7

