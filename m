Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab2J1HT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 03:19:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38566 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2J1HTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 03:19:48 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 8/9] mtd: mtd_speedtest: use random32_get_bytes
Date: Sun, 28 Oct 2012 16:19:05 +0900
Message-Id: <1351408746-8623-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/tests/mtd_speedtest.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/mtd/tests/mtd_speedtest.c b/drivers/mtd/tests/mtd_speedtest.c
index 42b0f74..57f0383 100644
--- a/drivers/mtd/tests/mtd_speedtest.c
+++ b/drivers/mtd/tests/mtd_speedtest.c
@@ -49,13 +49,6 @@ static int pgcnt;
 static int goodebcnt;
 static struct timeval start, finish;
 
-static void set_random_data(unsigned char *buf, size_t len)
-{
-	size_t i;
-
-	for (i = 0; i < len; ++i)
-		buf[i] = random32();
-}
 
 static int erase_eraseblock(int ebnum)
 {
@@ -396,7 +389,7 @@ static int __init mtd_speedtest_init(void)
 		goto out;
 	}
 
-	set_random_data(iobuf, mtd->erasesize);
+	random32_get_bytes(iobuf, mtd->erasesize);
 
 	err = scan_for_bad_eraseblocks();
 	if (err)
-- 
1.7.11.7

