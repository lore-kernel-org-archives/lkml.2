Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0DAQRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:17:13 -0400
Received: from thoth.sbs.de ([192.35.17.2]:24601 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757407Ab0DAQRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:17:05 -0400
Message-ID: <4BB4C6D6.6020602@siemens.com>
Date: Thu, 01 Apr 2010 18:16:22 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Frans Pop <elendil@planet.nl>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       "helight.xu@gmail.com" <helight.xu@gmail.com>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: [PATCH v2] proc: Report file name on detected read_proc overflow
References: <4BB49B0E.8070306@siemens.com> <201004011641.58462.elendil@planet.nl>
In-Reply-To: <201004011641.58462.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can help identifying the buggy read_proc handler.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 fs/proc/generic.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

changes in v2:
 - keep "Apparent buffer overflow" in the same source code line
 - quote the file name with ''

(Thanks, Frans!)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 08f4d71..ce14eca 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -132,7 +132,9 @@ __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 		if (start == NULL) {
 			if (n > PAGE_SIZE) {
 				printk(KERN_ERR
-				       "proc_file_read: Apparent buffer overflow!\n");
+				       "proc_file_read: Apparent buffer overflow"
+				       " reading '%s'!\n",
+				       file->f_path.dentry->d_name.name);
 				n = PAGE_SIZE;
 			}
 			n -= *ppos;
@@ -144,7 +146,9 @@ __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 		} else if (start < page) {
 			if (n > PAGE_SIZE) {
 				printk(KERN_ERR
-				       "proc_file_read: Apparent buffer overflow!\n");
+				       "proc_file_read: Apparent buffer overflow"
+				       " reading '%s'!\n",
+				       file->f_path.dentry->d_name.name);
 				n = PAGE_SIZE;
 			}
 			if (n > count) {
@@ -159,7 +163,9 @@ __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 			unsigned long startoff = (unsigned long)(start - page);
 			if (n > (PAGE_SIZE - startoff)) {
 				printk(KERN_ERR
-				       "proc_file_read: Apparent buffer overflow!\n");
+				       "proc_file_read: Apparent buffer overflow"
+				       " reading '%s'!\n",
+				       file->f_path.dentry->d_name.name);
 				n = PAGE_SIZE - startoff;
 			}
 			if (n > count)

