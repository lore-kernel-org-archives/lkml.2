Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2J1HVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 03:21:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38566 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2J1HTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 03:19:39 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 3/9] mtd: mtd_nandecctest: use random32_get_bytes instead of get_random_bytes()
Date: Sun, 28 Oct 2012 16:19:00 +0900
Message-Id: <1351408746-8623-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using random32_get_bytes() is enough.  Because this data is only used
for testing, not used for cryptographic use.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/tests/mtd_nandecctest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/tests/mtd_nandecctest.c b/drivers/mtd/tests/mtd_nandecctest.c
index a5fb9b0..0ddcbec 100644
--- a/drivers/mtd/tests/mtd_nandecctest.c
+++ b/drivers/mtd/tests/mtd_nandecctest.c
@@ -253,7 +253,7 @@ static int nand_ecc_test_run(const size_t size)
 		goto error;
 	}
 
-	get_random_bytes(correct_data, size);
+	random32_get_bytes(correct_data, size);
 	__nand_calculate_ecc(correct_data, size, correct_ecc);
 
 	for (i = 0; i < ARRAY_SIZE(nand_ecc_test); i++) {
-- 
1.7.11.7

