Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0GLUxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:53:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1783 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab0GLUvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:51:01 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
        coda@cs.cmu.edu, codalist@TELEMANN.coda.cs.cmu.edu
Subject: [PATCH 23/36] fs/coda: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:15 -0700
Message-Id: <a7be2383327c25d0ae51b6c7e582fdeae6ea76d9.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/coda/psdev.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 66b9cf7..2c4fd44 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -63,7 +63,7 @@ static struct class *coda_psdev_class;
 
 static unsigned int coda_psdev_poll(struct file *file, poll_table * wait)
 {
-        struct venus_comm *vcp = (struct venus_comm *) file->private_data;
+        struct venus_comm *vcp = file->private_data;
 	unsigned int mask = POLLOUT | POLLWRNORM;
 
 	poll_wait(file, &vcp->vc_waitq, wait);
@@ -95,7 +95,7 @@ static long coda_psdev_ioctl(struct file * filp, unsigned int cmd, unsigned long
 static ssize_t coda_psdev_write(struct file *file, const char __user *buf, 
 				size_t nbytes, loff_t *off)
 {
-        struct venus_comm *vcp = (struct venus_comm *) file->private_data;
+        struct venus_comm *vcp = file->private_data;
         struct upc_req *req = NULL;
         struct upc_req *tmp;
 	struct list_head *lh;
@@ -209,7 +209,7 @@ static ssize_t coda_psdev_read(struct file * file, char __user * buf,
 			       size_t nbytes, loff_t *off)
 {
 	DECLARE_WAITQUEUE(wait, current);
-        struct venus_comm *vcp = (struct venus_comm *) file->private_data;
+        struct venus_comm *vcp = file->private_data;
         struct upc_req *req;
 	ssize_t retval = 0, count = 0;
 
@@ -300,7 +300,7 @@ static int coda_psdev_open(struct inode * inode, struct file * file)
 
 static int coda_psdev_release(struct inode * inode, struct file * file)
 {
-	struct venus_comm *vcp = (struct venus_comm *) file->private_data;
+	struct venus_comm *vcp = file->private_data;
 	struct upc_req *req, *tmp;
 
 	if (!vcp || !vcp->vc_inuse ) {
-- 
1.7.1.337.g6068.dirty

