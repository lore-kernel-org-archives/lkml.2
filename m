Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2AKPKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 10:10:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33081 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2AKPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 10:10:02 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH]drivers:staging:android Typos: fix some comments that have typos in them.
Date: Wed, 11 Jan 2012 07:09:49 -0800
Message-Id: <1326294589-4872-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Below is a patch that fixes some typos in some comments.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/android/TODO     |    2 +-
 drivers/staging/android/binder.c |    2 +-
 drivers/staging/android/pmem.c   |   10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/TODO b/drivers/staging/android/TODO
index e59c5be..b15fb0d 100644
--- a/drivers/staging/android/TODO
+++ b/drivers/staging/android/TODO
@@ -3,7 +3,7 @@ TODO:
 	- sparse fixes
 	- rename files to be not so "generic"
 	- make sure things build as modules properly
-	- add proper arch dependancies as needed
+	- add proper arch dependencies as needed
 	- audit userspace interfaces to make sure they are sane
 
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and Cc:
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7491801..d3a95fe 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -257,7 +257,7 @@ struct binder_ref {
 };
 
 struct binder_buffer {
-	struct list_head entry; /* free and allocated entries by addesss */
+	struct list_head entry; /* free and allocated entries by addess */
 	struct rb_node rb_node; /* free entry by size or allocated entry */
 				/* by address */
 	unsigned free:1;
diff --git a/drivers/staging/android/pmem.c b/drivers/staging/android/pmem.c
index 7d97032..07fbe07 100644
--- a/drivers/staging/android/pmem.c
+++ b/drivers/staging/android/pmem.c
@@ -34,7 +34,7 @@
 
 #define PMEM_DEBUG 1
 
-/* indicates that a refernce to this file has been taken via get_pmem_file,
+/* indicates that a reference to this file has been taken via get_pmem_file,
  * the file should not be released until put_pmem_file is called */
 #define PMEM_FLAGS_BUSY 0x1
 /* indicates that this is a suballocation of a larger master range */
@@ -58,14 +58,14 @@ struct pmem_data {
 	/* see flags above for descriptions */
 	unsigned int flags;
 	/* protects this data field, if the mm_mmap sem will be held at the
-	 * same time as this sem, the mm sem must be taken first (as this is
+	 * same time as this sem, the mm sem must be taken first as this is
 	 * the order for vma_open and vma_close ops */
 	struct rw_semaphore sem;
 	/* info about the mmaping process */
 	struct vm_area_struct *vma;
 	/* task struct of the mapping process */
 	struct task_struct *task;
-	/* process id of teh mapping process */
+	/* process id of the mapping process */
 	pid_t pid;
 	/* file descriptor of the master */
 	int master_fd;
@@ -138,7 +138,7 @@ struct pmem_info {
 	 * dereferencing a pointer into bitmap
 	 *
 	 * pmem_data->sem protects the pmem data of a particular file
-	 * Many of the function that require the pmem_data->sem have a non-
+	 * Many of the functions that require the pmem_data->sem have a non-
 	 * locking version for when the caller is already holding that sem.
 	 *
 	 * IF YOU TAKE BOTH LOCKS TAKE THEM IN THIS ORDER:
@@ -296,7 +296,7 @@ static int pmem_release(struct inode *inode, struct file *file)
 
 	down_write(&data->sem);
 
-	/* if its not a conencted file and it has an allocation, free it */
+	/* if its not a connected file and it has an allocation, free it */
 	if (!(PMEM_FLAGS_CONNECTED & data->flags) && has_allocation(file)) {
 		down_write(&pmem[id].bitmap_sem);
 		ret = pmem_free(id, data->index);
-- 
1.7.5.4

