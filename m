Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1AFAs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:48:27 -0500
Received: from kroah.org ([198.145.64.141]:35790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab1AFAaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:07 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:03 2011
Message-Id: <20110106002303.656298940@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [074/152] tehuti: Firmware filename is tehuti/bdx.bin
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
---
 drivers/net/tehuti.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
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


