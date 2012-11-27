Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab2K0GF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:05:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50735 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2K0GFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:05:24 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, cbouatmailru@gmail.com, dwmw2@infradead.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: =?UTF-8?q?=5BPATCH=202/3=5D=20power=3A=20bq2415x=5Fcharger=3A=20Use=20module=5Fi2c=5Fdriver?=
Date: Tue, 27 Nov 2012 11:28:45 +0530
Message-Id: <1353995926-4621-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
References: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_i2c_driver() makes the code simpler by eliminating
module_init and module_exit calls.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/power/bq2415x_charger.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 2d1b568..54c4ebf 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1652,17 +1652,7 @@ static struct i2c_driver bq2415x_driver = {
 	.id_table = bq2415x_i2c_id_table,
 };
 
-static int __init bq2415x_init(void)
-{
-	return i2c_add_driver(&bq2415x_driver);
-}
-module_init(bq2415x_init);
-
-static void __exit bq2415x_exit(void)
-{
-	i2c_del_driver(&bq2415x_driver);
-}
-module_exit(bq2415x_exit);
+module_i2c_driver(bq2415x_driver);
 
 MODULE_AUTHOR("Pali Rohár <pali.rohar@gmail.com>");
 MODULE_DESCRIPTION("bq2415x charger driver");
-- 
1.7.4.1

