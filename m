Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0LHL4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 06:56:41 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:46601 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0LHL4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 06:56:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QtZVfwbcRY23nTGgS8fdNAQCrNaE/5wtOPPMCfDJ3MOjUOvDPpZdBRdDD77aJaZhxx
         oaYm7Uzj/xFZe95ZwjcUCI+QxVFyEZ/xRZNSb/5XepqnI3woLy68KemyY1R1bEeGur8+
         MtTQIRlpIJS/zCFbF/3A7XHsRx5pedCBEfoGs=
From: bookjovi@gmail.com
To: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com,
        hch@lst.de, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Cc: Jovi Zhang <bookjovi@gmail.com>
Subject: [PATCH] proc: fix single_open usage
Date: Mon,  6 Dec 2010 23:21:43 -0500
Message-Id: <1291695703-2093-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix some single_open function usage, use private_data as parameter

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

 fs/proc/base.c |   29 +++--------------------------
 1 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f3d02ca..74a7d92 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -751,14 +751,7 @@ static int proc_single_show(struct seq_file *m, void *v)
 
 static int proc_single_open(struct inode *inode, struct file *filp)
 {
-	int ret;
-	ret = single_open(filp, proc_single_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
-
-		m->private = inode;
-	}
-	return ret;
+	return single_open(filp, proc_single_show, inode);
 }
 
 static const struct file_operations proc_single_file_operations = {
@@ -1386,15 +1379,7 @@ sched_write(struct file *file, const char __user *buf,
 
 static int sched_open(struct inode *inode, struct file *filp)
 {
-	int ret;
-
-	ret = single_open(filp, sched_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
-
-		m->private = inode;
-	}
-	return ret;
+	return single_open(filp, sched_show, inode);
 }
 
 static const struct file_operations proc_pid_sched_operations = {
@@ -1454,15 +1439,7 @@ static int comm_show(struct seq_file *m, void *v)
 
 static int comm_open(struct inode *inode, struct file *filp)
 {
-	int ret;
-
-	ret = single_open(filp, comm_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
-
-		m->private = inode;
-	}
-	return ret;
+	return single_open(filp, comm_show, inode);
 }
 
 static const struct file_operations proc_pid_set_comm_operations = {
