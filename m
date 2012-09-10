Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2IJE5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:57:20 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58198 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2IJE5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:57:19 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 12:57:18 +0800
Message-ID: <CAPgLHd-NJFJQsAwGXwVzA_FcN8HOvkeYJLDy9s5dqGLLo9sVRw@mail.gmail.com>
Subject: [PATCH] configfs: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: jlbec@evilplan.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/configfs/dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7414ae2..3f15991 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1037,10 +1037,11 @@ static int configfs_dump(struct configfs_dirent *sd, int level)
 static int configfs_depend_prep(struct dentry *origin,
 				struct config_item *target)
 {
-	struct configfs_dirent *child_sd, *sd = origin->d_fsdata;
+	struct configfs_dirent *child_sd, *sd;
 	int ret = 0;
 
-	BUG_ON(!origin || !sd);
+	BUG_ON(!origin || !origin->d_fsdata);
+	sd = origin->d_fsdata;
 
 	if (sd->s_element == target)  /* Boo-yah */
 		goto out;

