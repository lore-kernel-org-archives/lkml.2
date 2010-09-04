Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0IDCM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:12:58 -0400
Received: from kroah.org ([198.145.64.141]:48542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab0IDCM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:12:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, stable <stable@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] sysfs: checking for NULL instead of ERR_PTR
Date: Fri,  3 Sep 2010 19:12:54 -0700
Message-Id: <1283566374-28798-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100904020948.GC28645@kroah.com>
References: <20100904020948.GC28645@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

d_path() returns an ERR_PTR and it doesn't return NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: stable <stable@kernel.org>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1b27b56..da3fefe 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -340,7 +340,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	char *p;
 
 	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
-	if (p)
+	if (!IS_ERR(p))
 		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	/* need attr_sd for attr and ops, its parent for kobj */
-- 
1.7.2

