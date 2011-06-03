Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1FCRXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:23:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37980 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1FCRXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UGtslUiAzaMpzi0oC+ERMpiFDiOZaGOF3ohHIuavi+QLo5U3RlA2IrxXMg22cZ6h4j
         lIXcAKMHLE7WJUAYMdwTW40vs+oYpYUeWTB0l1m0GRidSvrc1nmYgwJRmvBM95Rq1IR4
         MesHGmwA9yxACIGROTtvGmt+1dsYPLZ9/I/do=
From: Andre Bartke <andre.bartke@googlemail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] drivers/media: fix uninitialized variable
Date: Fri,  3 Jun 2011 19:22:01 +0200
Message-Id: <1307121721-6658-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mx1_camera_add_device() can return an
uninitialized value of ret.

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 drivers/media/video/mx1_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index bc0c23a..d9fc4b2 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -444,7 +444,7 @@ static int mx1_camera_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
-	int ret;
+	int ret = 0;
 
 	if (pcdev->icd) {
 		ret = -EBUSY;
-- 
1.7.5.2

