Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab1LGVT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:19:26 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:42490 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab1LGVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:19:24 -0500
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com
Subject: [PATCH 4/4] xen/privcmd: Remove unused support for arch specific privcmp mmap
Date: Wed,  7 Dec 2011 22:13:16 +0100
Message-Id: <1323292396-19523-5-git-send-email-waldi@debian.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323292396-19523-1-git-send-email-waldi@debian.org>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/xen/privcmd.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 863fbd0..c13d26a 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -365,7 +365,6 @@ static long privcmd_ioctl(struct file *file,
 	return ret;
 }
 
-#ifndef HAVE_ARCH_PRIVCMD_MMAP
 static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	printk(KERN_DEBUG "privcmd_fault: vma=%p %lx-%lx, pgoff=%lx, uv=%p\n",
@@ -398,7 +397,6 @@ static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma)
 {
 	return (xchg(&vma->vm_private_data, (void *)1) == NULL);
 }
-#endif
 
 const struct file_operations xen_privcmd_fops = {
 	.owner = THIS_MODULE,
-- 
1.7.7.3

