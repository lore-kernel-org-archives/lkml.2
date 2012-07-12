Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2GLGNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:13:50 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49771 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab2GLGNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:13:49 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sage Ahn <syahn@gctsemi.com>, Devendra Naga <devendra.aaru@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging/gdm72xx: use kzalloc for phydev and sdev
Date: Thu, 12 Jul 2012 11:58:37 +0545
Message-Id: <1342073617-12179-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in sdio probe function we are doing kmalloc which can be done using kzalloc.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/gdm72xx/gdm_sdio.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index 5e19b09..3e43c01 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -664,20 +664,17 @@ static int sdio_wimax_probe(struct sdio_func *func,
 	if (ret)
 		return ret;
 
-	phy_dev = kmalloc(sizeof(*phy_dev), GFP_KERNEL);
+	phy_dev = kzalloc(sizeof(*phy_dev), GFP_KERNEL);
 	if (phy_dev == NULL) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	sdev = kmalloc(sizeof(*sdev), GFP_KERNEL);
+	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
 	if (sdev == NULL) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	memset(phy_dev, 0, sizeof(*phy_dev));
-	memset(sdev, 0, sizeof(*sdev));
-
 	phy_dev->priv_dev = (void *)sdev;
 	phy_dev->send_func = gdm_sdio_send;
 	phy_dev->rcv_func = gdm_sdio_receive;
-- 
1.7.9.5

