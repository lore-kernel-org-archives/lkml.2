Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1GRRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 13:25:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61747 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab1GRRZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:25:26 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Wanlong Gao <wanlong.gao@gmail.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] fs:update the NOTE of the file_operations structure
Date: Tue, 19 Jul 2011 01:23:10 +0800
Message-Id: <1311009790-10312-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Big kernel lock had been removed and setlease now use the lock_flocks()
to hold a special spin lock file_lock_lock by Matthew.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 include/linux/fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b9792..fdeeb3f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1541,7 +1541,7 @@ struct block_device_operations;
 /*
  * NOTE:
  * all file operations except setlease can be called without
- * the big kernel lock held in all filesystems.
+ * the special spin_lock file_lock_lock held in all filesystems.
  */
 struct file_operations {
 	struct module *owner;
-- 
1.7.4.1

