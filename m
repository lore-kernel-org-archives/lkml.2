Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2KCPom (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 11:44:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48484 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab2KCPoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 11:44:38 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH v2 11/11] mtd: mtd_stresstest: use random32_get_bytes()
Date: Sun,  4 Nov 2012 00:43:42 +0900
Message-Id: <1351957422-23243-12-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351957422-23243-1-git-send-email-akinobu.mita@gmail.com>
References: <1351957422-23243-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
new patch from v2

 drivers/mtd/tests/mtd_stresstest.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/tests/mtd_stresstest.c b/drivers/mtd/tests/mtd_stresstest.c
index cb268ce..158d30f 100644
--- a/drivers/mtd/tests/mtd_stresstest.c
+++ b/drivers/mtd/tests/mtd_stresstest.c
@@ -282,8 +282,7 @@ static int __init mtd_stresstest_init(void)
 	}
 	for (i = 0; i < ebcnt; i++)
 		offsets[i] = mtd->erasesize;
-	for (i = 0; i < bufsize; i++)
-		writebuf[i] = random32();
+	random32_get_bytes(writebuf, bufsize);
 
 	err = scan_for_bad_eraseblocks();
 	if (err)
-- 
1.7.11.7

