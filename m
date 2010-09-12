Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0ILS5G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:57:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52144 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0ILS5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:57:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T2FfCLOwRIGSld46hkd8H8WMYxTIr1NMJWuSRWQ654woW860AorxsqKeNJhxj884zS
         XO7niFsXv/fIDuCLjAvABLMCr8gFzQ92AnSze+7BIUU+80sGvafH8WxKgAv99CVrwbjx
         i2kbqQZPcfGv9n7o3kLtxg4cXgRF889olR5RA=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ben Collins <bcollins@bluecherry.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: solo6010: fix signess bug
Date: Sun, 12 Sep 2010 22:56:57 +0400
Message-Id: <1284317820-4937-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

video_nr is unsigned, so check video_nr >= 0 doesn't make sense.
The only "negative" value may be -1, so explicitly check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/staging/solo6x10/solo6010-v4l2-enc.c |    2 +-
 drivers/staging/solo6x10/solo6010-v4l2.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/solo6x10/solo6010-v4l2-enc.c b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
index f114b4b..bbf3d9c 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2-enc.c
+++ b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
@@ -1497,7 +1497,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo6010_dev *solo_dev, u8 ch)
 		 "%s-enc (%i/%i)", SOLO6010_NAME, solo_dev->vfd->num,
 		 solo_enc->vfd->num);
 
-	if (video_nr >= 0)
+	if (video_nr != -1)
 		video_nr++;
 
 	spin_lock_init(&solo_enc->lock);
diff --git a/drivers/staging/solo6x10/solo6010-v4l2.c b/drivers/staging/solo6x10/solo6010-v4l2.c
index 9537cc6..9731fa0 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2.c
+++ b/drivers/staging/solo6x10/solo6010-v4l2.c
@@ -825,7 +825,7 @@ int solo_v4l2_init(struct solo6010_dev *solo_dev)
 	snprintf(solo_dev->vfd->name, sizeof(solo_dev->vfd->name), "%s (%i)",
 		 SOLO6010_NAME, solo_dev->vfd->num);
 
-	if (video_nr >= 0)
+	if (video_nr != -1)
 		video_nr++;
 
 	dev_info(&solo_dev->pdev->dev, "Display as /dev/video%d with "
-- 
1.7.0.4

