Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0EGPeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:34:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:22050 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab0EGPeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:34:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=tcMlnEyq5j7aZ0zA2JscxhJSSaxkm2o6AQrIwB2p+940wlHQV0mwC06vwt1zuGG3GM
         VxuvYanct0s0B2IMKAR4nbWr3MU4Fz06A3e9yx7XHneJ2k6Gl93pC3n9Z9dtXL1X8Lkv
         /orAkbMs3wvseEZiSKHYqZPb8gW0zvnjVaHaU=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH] uml: Convert to unlocked_ioctls to remove implicit BKL
Date: Fri,  7 May 2010 17:34:28 +0200
Message-Id: <1273246468-11048-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to hostaudio_ioctl and hostmixer_ioctl_mixdev to unlocked_ioctl

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/um/drivers/hostaudio_kern.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/hostaudio_kern.c b/arch/um/drivers/hostaudio_kern.c
index 368219c..ae42695 100644
--- a/arch/um/drivers/hostaudio_kern.c
+++ b/arch/um/drivers/hostaudio_kern.c
@@ -136,7 +136,7 @@ static unsigned int hostaudio_poll(struct file *file,
 	return mask;
 }
 
-static int hostaudio_ioctl(struct inode *inode, struct file *file,
+static long hostaudio_ioctl(struct file *file,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct hostaudio_state *state = file->private_data;
@@ -223,7 +223,7 @@ static int hostaudio_release(struct inode *inode, struct file *file)
 
 /* /dev/mixer file operations */
 
-static int hostmixer_ioctl_mixdev(struct inode *inode, struct file *file,
+static long hostmixer_ioctl_mixdev(struct file *file,
 				  unsigned int cmd, unsigned long arg)
 {
 	struct hostmixer_state *state = file->private_data;
@@ -289,7 +289,7 @@ static const struct file_operations hostaudio_fops = {
 	.read           = hostaudio_read,
 	.write          = hostaudio_write,
 	.poll           = hostaudio_poll,
-	.ioctl          = hostaudio_ioctl,
+	.unlocked_ioctl	= hostaudio_ioctl,
 	.mmap           = NULL,
 	.open           = hostaudio_open,
 	.release        = hostaudio_release,
@@ -298,7 +298,7 @@ static const struct file_operations hostaudio_fops = {
 static const struct file_operations hostmixer_fops = {
 	.owner          = THIS_MODULE,
 	.llseek         = no_llseek,
-	.ioctl          = hostmixer_ioctl_mixdev,
+	.unlocked_ioctl	= hostmixer_ioctl_mixdev,
 	.open           = hostmixer_open_mixdev,
 	.release        = hostmixer_release,
 };
-- 
1.6.6.1

