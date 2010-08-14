Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0HNAcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:32:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59888 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab0HNAcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=RnGs4jIkGZR42Mk/g1emxDlo6TvgjujNMt3URti/M7/zyYukd35TD3sOyogVBJyVqX
         Wagc3D0Dollwx9k1BmzgN9Cv+LI46yaRLTrLtdCBPgZa0qMhPDUJfG8f9+bTO9dLXIIx
         55k2e8sRHS1EMQoXNo430RiU9T206vZpggA9g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        John Kacur <jkacur@redhat.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/2] v4l: Remove reference to bkl ioctl in compat ioctl handling
Date: Sat, 14 Aug 2010 02:32:16 +0200
Message-Id: <1281745937-6467-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more users of struct file_operations:ioctl. These
can be safely removed.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index d2f20c2..073f013 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -228,11 +228,6 @@ static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	if (file->f_op->unlocked_ioctl)
 		ret = file->f_op->unlocked_ioctl(file, cmd, arg);
-	else if (file->f_op->ioctl) {
-		lock_kernel();
-		ret = file->f_op->ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
-		unlock_kernel();
-	}
 
 	return ret;
 }
@@ -973,7 +968,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret = -ENOIOCTLCMD;
 
-	if (!file->f_op->ioctl && !file->f_op->unlocked_ioctl)
+	if (!file->f_op->unlocked_ioctl)
 		return ret;
 
 	switch (cmd) {
-- 
1.6.2.3

