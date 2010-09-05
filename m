Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0IEByh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 21:54:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1360 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab0IEBxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 21:53:08 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/13] drivers/staging/lirc: Remove unnecessary casts of private_data
Date: Sat,  4 Sep 2010 18:52:47 -0700
Message-Id: <79fe585b980c9128383c9e41dd3a5685e4dd54b1.1283650107.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <cover.1283650107.git.joe@perches.com>
References: <cover.1283650107.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/lirc/lirc_imon.c  |    4 ++--
 drivers/staging/lirc/lirc_zilog.c |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lirc/lirc_imon.c b/drivers/staging/lirc/lirc_imon.c
index 818bec0..9949dfa 100644
--- a/drivers/staging/lirc/lirc_imon.c
+++ b/drivers/staging/lirc/lirc_imon.c
@@ -277,7 +277,7 @@ static int display_close(struct inode *inode, struct file *file)
 	struct imon_context *context = NULL;
 	int retval = 0;
 
-	context = (struct imon_context *)file->private_data;
+	context = file->private_data;
 
 	if (!context) {
 		err("%s: no context for device", __func__);
@@ -380,7 +380,7 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 		0x01, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF };
 	int *data_buf;
 
-	context = (struct imon_context *)file->private_data;
+	context = file->private_data;
 	if (!context) {
 		err("%s: no context for device", __func__);
 		return -ENODEV;
diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 100caab..9b77552 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -716,7 +716,7 @@ static loff_t lseek(struct file *filep, loff_t offset, int orig)
 /* copied from lirc_dev */
 static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 {
-	struct IR *ir = (struct IR *)filep->private_data;
+	struct IR *ir = filep->private_data;
 	unsigned char buf[ir->buf.chunk_size];
 	int ret = 0, written = 0;
 	DECLARE_WAITQUEUE(wait, current);
@@ -898,7 +898,7 @@ done:
 static ssize_t write(struct file *filep, const char *buf, size_t n,
 			  loff_t *ppos)
 {
-	struct IR *ir = (struct IR *)filep->private_data;
+	struct IR *ir = filep->private_data;
 	size_t i;
 	int failures = 0;
 
@@ -972,7 +972,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 /* copied from lirc_dev */
 static unsigned int poll(struct file *filep, poll_table *wait)
 {
-	struct IR *ir = (struct IR *)filep->private_data;
+	struct IR *ir = filep->private_data;
 	unsigned int ret;
 
 	dprintk("poll called\n");
@@ -994,7 +994,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 
 static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
-	struct IR *ir = (struct IR *)filep->private_data;
+	struct IR *ir = filep->private_data;
 	int result;
 	unsigned long mode, features = 0;
 
@@ -1086,7 +1086,7 @@ static int open(struct inode *node, struct file *filep)
 static int close(struct inode *node, struct file *filep)
 {
 	/* find our IR struct */
-	struct IR *ir = (struct IR *)filep->private_data;
+	struct IR *ir = filep->private_data;
 	if (ir == NULL) {
 		zilog_error("close: no private_data attached to the file!\n");
 		return -ENODEV;
-- 
1.7.2.19.g9a302

