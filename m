Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab1EFA0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:26:17 -0400
Received: from kroah.org ([198.145.64.141]:37385 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525Ab1EFA0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:18 2011
Message-Id: <20110506002218.634336154@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:22:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [136/143] tehuti: Firmware filename is tehuti/bdx.bin
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 46814e08d80f87449b5adb3d549a3cae6f9f8148 upstream.

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
@@ -2524,4 +2524,4 @@ module_exit(bdx_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(BDX_DRV_DESC);
-MODULE_FIRMWARE("tehuti/firmware.bin");
+MODULE_FIRMWARE("tehuti/bdx.bin");


