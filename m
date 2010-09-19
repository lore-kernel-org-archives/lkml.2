Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0ISMzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:55:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab0ISMzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cjVz5VYKBhpREenWbT1UFq8XUqgseonoLQQP5UROffpvCD8IApah/mYlknaNc9wN7f
         IU8ouoXp34qOM2ZITlZTTntDqWj+ym3PaGHGsUye8oPsQ8OHXeYQ7Rwu5bYSPmHEfCVs
         NvBzF+cCxvB2vvwYTDzxtKIwXNcsHQGt4CGxE=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Bill Pemberton <wfp5p@virginia.edu>, Milan Dadok <milan@dadok.name>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] staging: hv: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:55:11 +0400
Message-Id: <1284900911-24684-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/staging/hv/vmbus_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index ad29887..255e4b2 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -345,6 +345,7 @@ static int vmbus_bus_init(int (*drv_init)(struct hv_driver *drv))
 		DPRINT_ERR(VMBUS_DRV,
 			   "ERROR - Unable to register vmbus root device");
 
+		put_device(&dev_ctx->device);
 		free_irq(vmbus_irq, NULL);
 		bus_unregister(&vmbus_drv_ctx->bus);
 
-- 
1.7.0.4

