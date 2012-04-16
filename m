Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2DPIrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:47:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:21203 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2DPIrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:47:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="130048249"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: anton.vorontsov@linaro.org, alan@linux.intel.com,
        bruce.e.robertson@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/4] power-supply: smb347-charger: convert to use module_i2c_driver()
Date: Mon, 16 Apr 2012 11:48:38 +0300
Message-Id: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the amount of boilerplate code in the driver and makes it a bit
simpler.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/power/smb347-charger.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index ce1694d..066794d 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -1275,17 +1275,7 @@ static struct i2c_driver smb347_driver = {
 	.id_table     = smb347_id,
 };
 
-static int __init smb347_init(void)
-{
-	return i2c_add_driver(&smb347_driver);
-}
-module_init(smb347_init);
-
-static void __exit smb347_exit(void)
-{
-	i2c_del_driver(&smb347_driver);
-}
-module_exit(smb347_exit);
+module_i2c_driver(smb347_driver);
 
 MODULE_AUTHOR("Bruce E. Robertson <bruce.e.robertson@intel.com>");
 MODULE_AUTHOR("Mika Westerberg <mika.westerberg@linux.intel.com>");
-- 
1.7.9.1

