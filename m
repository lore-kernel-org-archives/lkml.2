Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0F2KQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:16:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab0F2KQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZSfdNJbG2xPMyan7tc6vk8ljqf9WV+viq9x3y5xoVB0bTjNeZjCLjNbYJ7ZtA5AY5W
         V2Y5b8MqYC931SQVKuzXmP7zm6Lg4B/B3i6BuMYLOEuf40DlYxzaw+HyMeJQOnCEpPFk
         42FWhgZx1z65uS7YN+a5XwmzLaSNfc8jED2KE=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>,
       Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
       Jochen Maes <jochen.maes@sejo.be>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 16/25] pmem: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:56 +0400
Message-Id: <1277806557-31248-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/dream/pmem.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
index 6387365..2e80f62 100644
--- a/drivers/staging/dream/pmem.c
+++ b/drivers/staging/dream/pmem.c
@@ -209,7 +209,7 @@ static int has_allocation(struct file *file)
 
 	if (unlikely(!file->private_data))
 		return 0;
-	data = (struct pmem_data *)file->private_data;
+	data = file->private_data;
 	if (unlikely(data->index < 0))
 		return 0;
 	return 1;
@@ -223,7 +223,7 @@ static int is_master_owner(struct file *file)
 
 	if (!is_pmem_file(file) || !has_allocation(file))
 		return 0;
-	data = (struct pmem_data *)file->private_data;
+	data = file->private_data;
 	if (PMEM_FLAGS_MASTERMAP & data->flags)
 		return 1;
 	master_file = fget_light(data->master_fd, &put_needed);
@@ -268,7 +268,7 @@ static void pmem_revoke(struct file *file, struct pmem_data *data);
 
 static int pmem_release(struct inode *inode, struct file *file)
 {
-	struct pmem_data *data = (struct pmem_data *)file->private_data;
+	struct pmem_data *data = file->private_data;
 	struct pmem_region_node *region_node;
 	struct list_head *elt, *elt2;
 	int id = get_id(file), ret = 0;
@@ -591,7 +591,7 @@ static int pmem_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
-	data = (struct pmem_data *)file->private_data;
+	data = file->private_data;
 	down_write(&data->sem);
 	/* check this file isn't already mmaped, for submaps check this file
 	 * has never been mmaped */
@@ -690,7 +690,7 @@ int get_pmem_user_addr(struct file *file, unsigned long *start,
 #endif
 		return -1;
 	}
-	data = (struct pmem_data *)file->private_data;
+	data = file->private_data;
 	down_read(&data->sem);
 	if (data->vma) {
 		*start = data->vma->vm_start;
@@ -712,7 +712,7 @@ int get_pmem_addr(struct file *file, unsigned long *start,
 	if (!is_pmem_file(file) || !has_allocation(file))
 		return -1;
 
-	data = (struct pmem_data *)file->private_data;
+	data = file->private_data;
 	if (data->index == -1) {
 #if PMEM_DEBUG
 		printk(KERN_INFO "pmem: requested pmem data from file with no "
@@ -766,7 +766,7 @@ void put_pmem_file(struct file *file)
 	if (!is_pmem_file(file))
 		return;
 	id = get_id(file);
-	data = (struct pmem_data *)file->private_data;
+	data = file->private_data;
 #if PMEM_DEBUG
 	down_write(&data->sem);
 	if (data->ref == 0) {
@@ -793,7 +793,7 @@ void flush_pmem_file(struct file *file, unsigned long offset, unsigned long len)
 		return;
 
 	id = get_id(file);
-	data = (struct pmem_data *)file->private_data;
+	data = file->private_data;
 	if (!pmem[id].cached)
 		return;
 
@@ -822,7 +822,7 @@ end:
 
 static int pmem_connect(unsigned long connect, struct file *file)
 {
-	struct pmem_data *data = (struct pmem_data *)file->private_data;
+	struct pmem_data *data = file->private_data;
 	struct pmem_data *src_data;
 	struct file *src_file;
 	int ret = 0, put_needed;
@@ -842,7 +842,7 @@ static int pmem_connect(unsigned long connect, struct file *file)
 		ret = -EINVAL;
 		goto err_bad_file;
 	}
-	src_data = (struct pmem_data *)src_file->private_data;
+	src_data = src_file->private_data;
 
 	if (has_allocation(file) && (data->index != src_data->index)) {
 		printk(KERN_INFO "pmem: file is already mapped but doesn't "
@@ -929,7 +929,7 @@ int pmem_remap(struct pmem_region *region, struct file *file,
 	struct mm_struct *mm = NULL;
 	struct list_head *elt, *elt2;
 	int id = get_id(file);
-	struct pmem_data *data = (struct pmem_data *)file->private_data;
+	struct pmem_data *data = file->private_data;
 
 	/* pmem region must be aligned on a page boundry */
 	if (unlikely(!PMEM_IS_PAGE_ALIGNED(region->offset) ||
@@ -1053,7 +1053,7 @@ static void pmem_revoke(struct file *file, struct pmem_data *data)
 
 static void pmem_get_size(struct pmem_region *region, struct file *file)
 {
-	struct pmem_data *data = (struct pmem_data *)file->private_data;
+	struct pmem_data *data = file->private_data;
 	int id = get_id(file);
 
 	if (!has_allocation(file)) {
@@ -1082,7 +1082,7 @@ static long pmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				region.offset = 0;
 				region.len = 0;
 			} else {
-				data = (struct pmem_data *)file->private_data;
+				data = file->private_data;
 				region.offset = pmem_start_addr(id, data);
 				region.len = pmem_len(id, data);
 			}
@@ -1099,7 +1099,7 @@ static long pmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			if (copy_from_user(&region, (void __user *)arg,
 						sizeof(struct pmem_region)))
 				return -EFAULT;
-			data = (struct pmem_data *)file->private_data;
+			data = file->private_data;
 			return pmem_remap(&region, file, PMEM_MAP);
 		}
 		break;
@@ -1109,7 +1109,7 @@ static long pmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			if (copy_from_user(&region, (void __user *)arg,
 						sizeof(struct pmem_region)))
 				return -EFAULT;
-			data = (struct pmem_data *)file->private_data;
+			data = file->private_data;
 			return pmem_remap(&region, file, PMEM_UNMAP);
 			break;
 		}
@@ -1139,7 +1139,7 @@ static long pmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		{
 			if (has_allocation(file))
 				return -EINVAL;
-			data = (struct pmem_data *)file->private_data;
+			data = file->private_data;
 			data->index = pmem_allocate(id, arg);
 			break;
 		}
-- 
1.7.0.4

