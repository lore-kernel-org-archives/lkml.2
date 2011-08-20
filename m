Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1HTEO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 00:14:28 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60294 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1HTEOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 00:14:17 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@suse.de, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH v2] drivers:uio:change the goto label to consistent with others
Date: Sat, 20 Aug 2011 12:12:08 +0800
Message-Id: <1313813528-30913-2-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313813528-30913-1-git-send-email-wanlong.gao@gmail.com>
References: <1313813528-30913-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

sorry for v1's typo mistake.
Thanks

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

