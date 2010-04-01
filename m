Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0DANiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:38:00 -0400
Received: from thoth.sbs.de ([192.35.17.2]:16920 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0DANhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:37:54 -0400
X-Greylist: delayed 1688 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2010 09:37:53 EDT
Message-ID: <4BB49B0E.8070306@siemens.com>
Date: Thu, 01 Apr 2010 15:09:34 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Helight.Xu" <helight.xu@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] proc: Report file name on detected read_proc overflow
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can help identifying the buggy read_proc handler.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 fs/proc/generic.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 08f4d71..cc7e671 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -132,7 +132,9 @@ __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 		if (start == NULL) {
 			if (n > PAGE_SIZE) {
 				printk(KERN_ERR
-				       "proc_file_read: Apparent buffer overflow!\n");
+				       "proc_file_read: Apparent buffer "
+				       "overflow reading \"%s\"!\n",
+				       file->f_path.dentry->d_name.name);
 				n = PAGE_SIZE;
 			}
 			n -= *ppos;
@@ -144,7 +146,9 @@ __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 		} else if (start < page) {
 			if (n > PAGE_SIZE) {
 				printk(KERN_ERR
-				       "proc_file_read: Apparent buffer overflow!\n");
+				       "proc_file_read: Apparent buffer "
+				       "overflow reading \"%s\"!\n",
+				       file->f_path.dentry->d_name.name);
 				n = PAGE_SIZE;
 			}
 			if (n > count) {
@@ -159,7 +163,9 @@ __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 			unsigned long startoff = (unsigned long)(start - page);
 			if (n > (PAGE_SIZE - startoff)) {
 				printk(KERN_ERR
-				       "proc_file_read: Apparent buffer overflow!\n");
+				       "proc_file_read: Apparent buffer "
+				       "overflow reading \"%s\"!\n",
+				       file->f_path.dentry->d_name.name);
 				n = PAGE_SIZE - startoff;
 			}
 			if (n > count)

