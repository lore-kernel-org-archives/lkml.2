Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2FEPn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:43:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55341 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091Ab2FEPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:43:56 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] Extcon: Don't try to create duplicate link names
Date: Tue,  5 Jun 2012 16:43:53 +0100
Message-Id: <1338911033-14869-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't create a link from the device to the compatibility switch class
since we already create a link from the device to to the extcon class
object and we try to use the same name for both links. This causes a loud
complaint from sysfs on boot.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon_class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 99f7227..f6419f9 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -762,7 +762,7 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 #if defined(CONFIG_ANDROID)
 	if (switch_class)
 		ret = class_compat_create_link(switch_class, edev->dev,
-					       dev);
+					       NULL);
 #endif /* CONFIG_ANDROID */
 
 	spin_lock_init(&edev->lock);
-- 
1.7.10

