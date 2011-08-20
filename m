Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1HTDqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 23:46:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61834 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1HTDqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 23:46:40 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@suse.de, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] drivers:uid:change the goto lebel to consistent with others
Date: Sat, 20 Aug 2011 11:44:30 +0800
Message-Id: <1313811870-29159-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Remove one *goto* label in uio.c.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/uio/uio.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index d2efe82..c89f12a 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -750,14 +750,13 @@ static int uio_major_init(void)
 
 	uio_major = MAJOR(uio_dev);
 	uio_cdev = cdev;
-	result = 0;
-out:
-	return result;
+	return 0;
 out_put:
 	kobject_put(&cdev->kobj);
 out_unregister:
 	unregister_chrdev_region(uio_dev, UIO_MAX_DEVICES);
-	goto out;
+out:
+	return result;
 }
 
 static void uio_major_cleanup(void)
-- 
1.7.4.1

