Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0GLUxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:53:01 -0400
Received: from mail.perches.com ([173.55.12.10]:1785 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab0GLUvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:51:03 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 28/36] fs: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:20 -0700
Message-Id: <88719afae7220e41bb1cca1cf59c141f38ffefc3.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/seq_file.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index e1f437b..0e7cb13 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -131,7 +131,7 @@ Eoverflow:
  */
 ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 {
-	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct seq_file *m = file->private_data;
 	size_t copied = 0;
 	loff_t pos;
 	size_t n;
@@ -280,7 +280,7 @@ EXPORT_SYMBOL(seq_read);
  */
 loff_t seq_lseek(struct file *file, loff_t offset, int origin)
 {
-	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct seq_file *m = file->private_data;
 	loff_t retval = -EINVAL;
 
 	mutex_lock(&m->lock);
@@ -324,7 +324,7 @@ EXPORT_SYMBOL(seq_lseek);
  */
 int seq_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct seq_file *m = file->private_data;
 	kfree(m->buf);
 	kfree(m);
 	return 0;
-- 
1.7.1.337.g6068.dirty

