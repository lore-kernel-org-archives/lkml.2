Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0IEBzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 21:55:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1341 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab0IEBxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 21:53:07 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] drivers/s390: Remove unnecessary casts of private_data
Date: Sat,  4 Sep 2010 18:52:45 -0700
Message-Id: <ffd65b5efc206c3bb180addeeab41a26f15991a7.1283650107.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <cover.1283650107.git.joe@perches.com>
References: <cover.1283650107.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/char/vmcp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 04e532e..19a14d9 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -47,7 +47,7 @@ static int vmcp_release(struct inode *inode, struct file *file)
 {
 	struct vmcp_session *session;
 
-	session = (struct vmcp_session *)file->private_data;
+	session = file->private_data;
 	file->private_data = NULL;
 	free_pages((unsigned long)session->response, get_order(session->bufsize));
 	kfree(session);
@@ -94,7 +94,7 @@ vmcp_write(struct file *file, const char __user *buff, size_t count,
 		return -EFAULT;
 	}
 	cmd[count] = '\0';
-	session = (struct vmcp_session *)file->private_data;
+	session = file->private_data;
 	if (mutex_lock_interruptible(&session->mutex)) {
 		kfree(cmd);
 		return -ERESTARTSYS;
@@ -136,7 +136,7 @@ static long vmcp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int __user *argp;
 	int temp;
 
-	session = (struct vmcp_session *)file->private_data;
+	session = file->private_data;
 	if (is_compat_task())
 		argp = compat_ptr(arg);
 	else
-- 
1.7.2.19.g9a302

