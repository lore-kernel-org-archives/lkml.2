Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab2BNEME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:12:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36285 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2BNEMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:12:00 -0500
From: Yang Bai <hamo.by@gmail.com>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Bai <hamo.by@gmail.com>
Subject: [PATCH] scsi: if sd card is removed, do not revalidate it
Date: Tue, 14 Feb 2012 12:10:54 +0800
Message-Id: <1329192654-11284-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During revalidating, if sd card is removed, scsi_device
will be NULL, so we should not revalidate or it will cause
a panic.
This problem is report at:
http://comments.gmane.org/gmane.linux.kernel/1250235

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 drivers/scsi/sd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c691fb5..470339c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2370,10 +2370,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 				      "sd_revalidate_disk\n"));
 
 	/*
-	 * If the device is offline, don't try and read capacity or any
+	 * If the device is removed or offline, don't try and read capacity or any
 	 * of the other niceties.
 	 */
-	if (!scsi_device_online(sdp))
+	if (!sdp || !scsi_device_online(sdp))
 		goto out;
 
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
-- 
1.7.9

