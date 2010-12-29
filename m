Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0L2N7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 08:59:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59716 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0L2N7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 08:59:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Eb/DX/38jEY4+TW+M+zA9ubZy0DeIfwHc41FsIx8qMIGsUMBX4gwkiOnY/TduxDEiA
         afk4MtP8y3dqSZKc3Ec0SiSRwSCpEvHcJhixSs9WdkmRer/Ao7+wr33aqNUr2SVMG266
         5hqAqwWUdy6XcMhkAc3oConqz66MgyQA1y7rE=
From: yangsheng <sickamd@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, yangsheng <sickamd@gmail.com>
Subject: [PATCH] Update atime from future.
Date: Wed, 29 Dec 2010 21:58:41 +0800
Message-Id: <1293631121-12667-1-git-send-email-sickamd@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: sickamd@gmail.com
---
 fs/inode.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index da85e56..6c8effd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1469,7 +1469,13 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 		return 1;
 
 	/*
-	 * Is the previous atime value older than a day? If yes,
+	 * Is the previous atime value in future? If yes,
+	 * update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) < 0)
+		return 1;
+	/*
+	 * Is the previous atime value old than a day? If yes,
 	 * update atime:
 	 */
 	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
-- 
1.7.2.3

