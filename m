Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab0GGVm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:42:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49482 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740Ab0GGVkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 04/18] ib/qib: use generic_file_llseek
Date: Wed,  7 Jul 2010 23:40:06 +0200
Message-Id: <1278538820-1392-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WvI2VKG8hklYke4clEl/3dDw33XgbEvKKO5W8UkupbP
 2JvWnw2qOLMTEByqmVm66sQ/FbIEFyL77E7JCyHb+FEl59CksZ
 /vt7RWRxPeu6rMx3SGbw7jnPlXwxWkB7fHETBIibmsOFRnXjBB
 5Q7QjHJPsAMbaOstQaP0MRNRha+64KKqduGoEUqs6VFa5OvOCL
 RVzMxZQDI4Q77CnyCIOoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the default llseek action gets changed to
no_llseek, all file systems relying on the
current behaviour need to set explicit .llseek
operations.

In case of qib_fs, we want the files to be
seekable, so generic_file_llseek fits best.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/qib/qib_fs.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 844954b..9f989c0 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -135,8 +135,8 @@ static ssize_t driver_names_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations driver_ops[] = {
-	{ .read = driver_stats_read, },
-	{ .read = driver_names_read, },
+	{ .read = driver_stats_read, .llseek = generic_file_llseek, },
+	{ .read = driver_names_read, .llseek = generic_file_llseek, },
 };
 
 /* read the per-device counters */
@@ -164,8 +164,8 @@ static ssize_t dev_names_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations cntr_ops[] = {
-	{ .read = dev_counters_read, },
-	{ .read = dev_names_read, },
+	{ .read = dev_counters_read, .llseek = generic_file_llseek, },
+	{ .read = dev_names_read, .llseek = generic_file_llseek, },
 };
 
 /*
@@ -210,9 +210,9 @@ static ssize_t portcntrs_2_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations portcntr_ops[] = {
-	{ .read = portnames_read, },
-	{ .read = portcntrs_1_read, },
-	{ .read = portcntrs_2_read, },
+	{ .read = portnames_read, .llseek = generic_file_llseek, },
+	{ .read = portcntrs_1_read, .llseek = generic_file_llseek, },
+	{ .read = portcntrs_2_read, .llseek = generic_file_llseek, },
 };
 
 /*
@@ -261,8 +261,8 @@ static ssize_t qsfp_2_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations qsfp_ops[] = {
-	{ .read = qsfp_1_read, },
-	{ .read = qsfp_2_read, },
+	{ .read = qsfp_1_read, .llseek = generic_file_llseek, },
+	{ .read = qsfp_2_read, .llseek = generic_file_llseek, },
 };
 
 static ssize_t flash_read(struct file *file, char __user *buf,
-- 
1.7.1

