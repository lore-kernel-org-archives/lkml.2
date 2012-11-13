Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2KMNkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:40:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62396 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab2KMNhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:37:45 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH v3 06/11] mtd: mtd_nandecctest: use prandom_bytes instead of get_random_bytes()
Date: Tue, 13 Nov 2012 22:37:05 +0900
Message-Id: <1352813830-4624-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352813830-4624-1-git-send-email-akinobu.mita@gmail.com>
References: <1352813830-4624-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using prandom_bytes() is enough.  Because this data is only used
for testing, not used for cryptographic use.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
* v3
- rename random32_get_bytes to prandom_bytes

 drivers/mtd/tests/mtd_nandecctest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/tests/mtd_nandecctest.c b/drivers/mtd/tests/mtd_nandecctest.c
index a5fb9b0..9b7b9fa 100644
--- a/drivers/mtd/tests/mtd_nandecctest.c
+++ b/drivers/mtd/tests/mtd_nandecctest.c
@@ -253,7 +253,7 @@ static int nand_ecc_test_run(const size_t size)
 		goto error;
 	}
 
-	get_random_bytes(correct_data, size);
+	prandom_bytes(correct_data, size);
 	__nand_calculate_ecc(correct_data, size, correct_ecc);
 
 	for (i = 0; i < ARRAY_SIZE(nand_ecc_test); i++) {
-- 
1.7.11.7

