Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1G2IfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:35:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62510 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab1G2IfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:35:13 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] fs:remove a no needed mutex_unlock in devtmpfs
Date: Fri, 29 Jul 2011 16:34:04 +0800
Message-Id: <1311928444-4848-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-29 16:34:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-29 16:34:09,
	Serialize complete at 2011-07-29 16:34:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According ed75e95de574c99575e5f3e1d9ca59ea8c12a9cb, Al killed the
lookup_create(), this function will return with an mutex locked,
and it called by dev_mkdir() previously. then unlock this mutex
in dev_mkdir(), but when lookup_create() is replaced by kern_path_create(),
no locked mutex returned, so no need to unlock the mutex.

Al, is it right?
Thanks

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/base/devtmpfs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index b89fffc..5384883 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -157,7 +157,6 @@ static int dev_mkdir(const char *name, mode_t mode)
 		/* mark as kernel-created inode */
 		dentry->d_inode->i_private = &thread;
 	dput(dentry);
-	mutex_unlock(&path.dentry->d_inode->i_mutex);
 	path_put(&path);
 	return err;
 }
-- 
1.7.6

