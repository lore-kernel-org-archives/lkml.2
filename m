Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab1LJSaD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 13:30:03 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51214 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1LJSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 13:30:01 -0500
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com
Subject: [PATCH 4/6] xen/privcmd: Remove unused support for arch specific privcmp mmap
Date: Sat, 10 Dec 2011 19:29:49 +0100
Message-Id: <1323541791-18006-5-git-send-email-waldi@debian.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323541791-18006-1-git-send-email-waldi@debian.org>
References: <1323541791-18006-1-git-send-email-waldi@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was used for ia64. But there is no working ia64 support in sight,
so remove it for now.

Signed-off-by: Bastian Blank <waldi@debian.org>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/privcmd.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 4e8d3da..ccee0f1 100644
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

