Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab2CMAYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:48816 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965161Ab2CMAYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 164/196] tehuti: Firmware filename is tehuti/bdx.bin
Date: Mon, 12 Mar 2012 20:21:17 -0400
Message-Id: <1331598109-31424-119-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 46814e08d80f87449b5adb3d549a3cae6f9f8148 upstream.

My conversion of tehuti to use request_firmware() was confused about
the filename of the firmware blob.  Change the driver to match the
blob.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/tehuti.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index f549309..cf4529c 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -324,7 +324,7 @@ static int bdx_fw_load(struct bdx_priv *priv)
 	ENTER;
 	master = READ_REG(priv, regINIT_SEMAPHORE);
 	if (!READ_REG(priv, regINIT_STATUS) && master) {
-		rc = request_firmware(&fw, "tehuti/firmware.bin", &priv->pdev->dev);
+		rc = request_firmware(&fw, "tehuti/bdx.bin", &priv->pdev->dev);
 		if (rc)
 			goto out;
 		bdx_tx_push_desc_safe(priv, (char *)fw->data, fw->size);
@@ -2518,4 +2518,4 @@ module_exit(bdx_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(BDX_DRV_DESC);
-MODULE_FIRMWARE("tehuti/firmware.bin");
+MODULE_FIRMWARE("tehuti/bdx.bin");
-- 
1.7.9.3

