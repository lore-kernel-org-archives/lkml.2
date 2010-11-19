Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab0KSSl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:41:58 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32907 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab0KSSl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:41:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=OuJmeZWyTITBHm4GhLkRqrHsX2/bClQ2DIjLTg2KqeEAH0HU9pXRNIFf1qUHFqPDvy
         Oeb8Vd7I1cyXhf9EKGuhz+SlSUDmV2xDKLC3dh+0bIFBfPGM3K48P5vNGUXOtrf88j+f
         juz+WZ5SEzujdV5Trr0sXMemJvHqRYqEIEm8k=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: video: pvrusb2: fix memory leak
Date: Fri, 19 Nov 2010 21:41:49 +0300
Message-Id: <1290192109-11611-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use put_device() instead of kfree() because of device name leak.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
index 3d7e5aa..281806b 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -647,7 +647,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "device_register failed");
-		kfree(class_dev);
+		put_device(class_dev);
 		return;
 	}
 
-- 
1.7.0.4

