Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417Ab2LHRiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 12:38:22 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:60205 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888Ab2LHRiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 12:38:20 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2] drivers/base/core.c: Remove two unused variables and two useless calls to kfree
Date: Sat,  8 Dec 2012 15:38:06 -0200
Message-Id: <1354988286-2303-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

old_class_name, and new_class_name are never used. This patch remove the
declaration and calls to kfree.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r1 forall@
type T; identifier i;
@@
* T *i = NULL;
  ... when != i
* kfree(i);
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V1: Added drivers/base/core.c: to subject

 drivers/base/core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a235085..27603a6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1685,8 +1685,6 @@ EXPORT_SYMBOL_GPL(device_destroy);
  */
 int device_rename(struct device *dev, const char *new_name)
 {
-	char *old_class_name = NULL;
-	char *new_class_name = NULL;
 	char *old_device_name = NULL;
 	int error;
 
@@ -1717,8 +1715,6 @@ int device_rename(struct device *dev, const char *new_name)
 out:
 	put_device(dev);
 
-	kfree(new_class_name);
-	kfree(old_class_name);
 	kfree(old_device_name);
 
 	return error;
-- 
1.7.11.7

