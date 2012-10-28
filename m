Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2J1HTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 03:19:44 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51191 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2J1HTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 03:19:41 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 4/9] mtd: nandsim: use random32_get_bytes
Date: Sun, 28 Oct 2012 16:19:01 +0900
Message-Id: <1351408746-8623-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also removes unnecessary memset call which is immediately overwritten
with random bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/nandsim.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index a932c48..d074b4c 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -1397,10 +1397,7 @@ int do_read_error(struct nandsim *ns, int num)
 	unsigned int page_no = ns->regs.row;
 
 	if (read_error(page_no)) {
-		int i;
-		memset(ns->buf.byte, 0xFF, num);
-		for (i = 0; i < num; ++i)
-			ns->buf.byte[i] = random32();
+		random32_get_bytes(ns->buf.byte, num);
 		NS_WARN("simulating read error in page %u\n", page_no);
 		return 1;
 	}
-- 
1.7.11.7

