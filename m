Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2AWCE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 21:04:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64569 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2AWCE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 21:04:27 -0500
Date: Sun, 22 Jan 2012 21:04:21 -0500
From: Tracey Dent <tdent48227@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: swetland@google.com, greg@kroah.com, greg@suse.de
Subject: [PATCH][GIT PULL] Minor Cleanups
Message-ID: <20120123020421.GA9455@tj-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg can you pull these changes into your tree. They are trival fixes, 
nothing major as you can see below.

Please pull from:
  git://github.com/Tdent48227/linux.git next

thanks,

tracey 
----------------------------------------------------------------
Tracey Dent (3):
      drivers/staging/android/ashmem.c: Cleanups
      drivers/staging/android/pmem.c: Cleanups
      drivers/staging/android/timed_gpio.c: Stlye fixes

 drivers/staging/android/ashmem.c     |    4 ++--
 drivers/staging/android/pmem.c       |   10 +++++-----
 drivers/staging/android/timed_gpio.c |    6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 99052bf..9f1f27e 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -315,7 +315,7 @@ static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
 	get_file(asma->file);
 
 	/*
-	 * XXX - Reworked to use shmem_zero_setup() instead of 
+	 * XXX - Reworked to use shmem_zero_setup() instead of
 	 * shmem_set_file while we're in staging. -jstultz
 	 */
 	if (vma->vm_flags & VM_SHARED) {
@@ -680,7 +680,7 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-static struct file_operations ashmem_fops = {
+static const struct file_operations ashmem_fops = {
 	.owner = THIS_MODULE,
 	.open = ashmem_open,
 	.release = ashmem_release,
diff --git a/drivers/staging/android/pmem.c b/drivers/staging/android/pmem.c
index 7d97032..b57cdce 100644
--- a/drivers/staging/android/pmem.c
+++ b/drivers/staging/android/pmem.c
@@ -92,7 +92,7 @@ struct pmem_region_node {
 
 #define PMEM_DEBUG_MSGS 0
 #if PMEM_DEBUG_MSGS
-#define DLOG(fmt,args...) \
+#define DLOG(fmt, args...) \
 	do { printk(KERN_INFO "[%s:%s:%d] "fmt, __FILE__, __func__, __LINE__, \
 		    ##args); } \
 	while (0)
@@ -708,9 +708,9 @@ int get_pmem_addr(struct file *file, unsigned long *start,
 	struct pmem_data *data;
 	int id;
 
-	if (!is_pmem_file(file) || !has_allocation(file)) {
+	if (!is_pmem_file(file) || !has_allocation(file))
 		return -1;
-	}
+
 
 	data = (struct pmem_data *)file->private_data;
 	if (data->index == -1) {
@@ -789,9 +789,9 @@ void flush_pmem_file(struct file *file, unsigned long offset, unsigned long len)
 	struct list_head *elt;
 	void *flush_start, *flush_end;
 
-	if (!is_pmem_file(file) || !has_allocation(file)) {
+	if (!is_pmem_file(file) || !has_allocation(file))
 		return;
-	}
+
 
 	id = get_id(file);
 	data = (struct pmem_data *)file->private_data;
diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index a64481c..bc723ef 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -29,9 +29,9 @@ struct timed_gpio_data {
 	struct timed_output_dev dev;
 	struct hrtimer timer;
 	spinlock_t lock;
-	unsigned 	gpio;
-	int 		max_timeout;
-	u8 		active_low;
+	unsigned gpio;
+	int max_timeout;
+	u8 active_low;
 };
 
 static enum hrtimer_restart gpio_timer_func(struct hrtimer *timer)
