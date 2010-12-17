Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0LQONM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:13:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39466 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754927Ab0LQONL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:13:11 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>
Cc: Joe Jin <joe.jin@oracle.com>,
        Alexander Indenbaum <baum@tehutinetworks.net>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guru Anbalagane <guru.anbalagane@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Jaswinder Singh Rajput <jaswinder@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 14:13:03 +0000
Message-ID: <1292595184.3136.843.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH net-2.6] tehuti: Firmware filename is tehuti/bdx.bin
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My conversion of tehuti to use request_firmware() was confused about
the filename of the firmware blob.  Change the driver to match the
blob.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@kernel.org [2.6.32+]
---
 drivers/net/tehuti.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 8b3dc1e..296000b 100644
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
@@ -2510,4 +2510,4 @@ module_exit(bdx_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(BDX_DRV_DESC);
-MODULE_FIRMWARE("tehuti/firmware.bin");
+MODULE_FIRMWARE("tehuti/bdx.bin");
-- 
1.7.2.3


