Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0ISM4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:56:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44711 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0ISMzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MfVSqOElqCi/WH6bAj26UsfpQVm16RTZwJqxKwT7ZHjaaatef/7hfj8X5DYtlb1uaA
         D0L7+AFNE907CBOfgZLU0GA6ex1MuyPxNyMsXzGq9/ENHZwGKhKk/+dp8vvq7Bii7r9j
         4rx1svsFYWv0PmrJ3tD+fQqiRWzjoySIyYl9I=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        osd-dev@open-osd.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] scsi: osd: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:55:07 +0400
Message-Id: <1284900907-24621-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/scsi/osd/osd_uld.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index cefb2c0..3e0edc2 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -474,7 +474,7 @@ static int osd_probe(struct device *dev)
 	error = device_register(&oud->class_dev);
 	if (error) {
 		OSD_ERR("device_register failed => %d\n", error);
-		goto err_put_cdev;
+		goto err_put_device;
 	}
 
 	get_device(&oud->class_dev);
@@ -482,6 +482,8 @@ static int osd_probe(struct device *dev)
 	OSD_INFO("osd_probe %s\n", disk->disk_name);
 	return 0;
 
+err_put_device:
+	put_device(&oud->class_dev);
 err_put_cdev:
 	cdev_del(&oud->cdev);
 err_put_disk:
-- 
1.7.0.4

