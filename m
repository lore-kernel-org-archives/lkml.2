Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1BBAoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:47465 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab1BBAoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960642"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: ben@decadent.org.uk, andy@greyhouse.net, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [71/139] tehuti: Firmware filename is tehuti/bdx.bin
Message-Id: <20110202004428.1D2D33E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 46814e08d80f87449b5adb3d549a3cae6f9f8148 ]

My conversion of tehuti to use request_firmware() was confused about
the filename of the firmware blob.  Change the driver to match the
blob.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/tehuti.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/net/tehuti.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/tehuti.c
+++ linux-2.6.35.y/drivers/net/tehuti.c
@@ -324,7 +324,7 @@ static int bdx_fw_load(struct bdx_priv *
 	ENTER;
 	master = READ_REG(priv, regINIT_SEMAPHORE);
 	if (!READ_REG(priv, regINIT_STATUS) && master) {
-		rc = request_firmware(&fw, "tehuti/firmware.bin", &priv->pdev->dev);
+		rc = request_firmware(&fw, "tehuti/bdx.bin", &priv->pdev->dev);
 		if (rc)
 			goto out;
 		bdx_tx_push_desc_safe(priv, (char *)fw->data, fw->size);
@@ -2516,4 +2516,4 @@ module_exit(bdx_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(BDX_DRV_DESC);
-MODULE_FIRMWARE("tehuti/firmware.bin");
+MODULE_FIRMWARE("tehuti/bdx.bin");
