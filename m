Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0ISMza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:55:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44711 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0ISMz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qCSCWQBaQeh8DLzPZ3hv3S0XJKGNY0aW3t9D/3DUSmdPoKhiosUCCJDOtEd88AcmZt
         31sAml8Q/4qg6CjGJBw3EFyhy7yhGSX/3tos+xeKJne+8GsI/Tr7DCGhKw9BtO+cD0ah
         fDjv417DwUxApIymbkR8GfphgeCiLRB2emCRY=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] zorro: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:55:21 +0400
Message-Id: <1284900921-24814-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested at all.

 drivers/zorro/zorro.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index 6455f3a..e0c2807 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -142,6 +142,7 @@ static int __init amiga_zorro_probe(struct platform_device *pdev)
 	error = device_register(&bus->dev);
 	if (error) {
 		pr_err("Zorro: Error registering zorro_bus\n");
+		put_device(&bus->dev);
 		kfree(bus);
 		return error;
 	}
@@ -175,6 +176,7 @@ static int __init amiga_zorro_probe(struct platform_device *pdev)
 		if (error) {
 			dev_err(&bus->dev, "Error registering device %s\n",
 				z->name);
+			put_device(&z->dev);
 			continue;
 		}
 		error = zorro_create_sysfs_dev_files(z);
-- 
1.7.0.4

