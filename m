Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2JRRMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:12:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62446 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab2JRRMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:12:20 -0400
From: anish kumar <anish198519851985@gmail.com>
To: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [PATCH] extcon: driver model release call not needed
Date: Fri, 19 Oct 2012 02:12:06 +0900
Message-Id: <1350580326-1574-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

We don't need a release call in this file as we are doing
everything needed in unregister call and we don't have any
more pointer to free up.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/extcon/extcon-class.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 946a318..cf30eb1 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -585,9 +585,7 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
 
 static void extcon_dev_release(struct device *dev)
 {
-	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
-
-	extcon_cleanup(edev, true);
+	/* We don't have any thing to free here */
 }
 
 static const char *muex_name = "mutually_exclusive";
-- 
1.7.1

