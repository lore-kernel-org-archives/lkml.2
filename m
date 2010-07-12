Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0GLUu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:58 -0400
Received: from mail.perches.com ([173.55.12.10]:1760 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab0GLUuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:55 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        linux-usb@vger.kernel.org, legousb-devel@lists.sourceforge.net
Subject: [PATCH 20/36] drivers/usb/misc: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:12 -0700
Message-Id: <d777d5bcc287f389dbb6293a67891f41a4457cee.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/misc/ftdi-elan.c        |    4 ++--
 drivers/usb/misc/iowarrior.c        |    8 ++++----
 drivers/usb/misc/legousbtower.c     |    6 +++---
 drivers/usb/misc/sisusbvga/sisusb.c |   10 +++++-----
 drivers/usb/misc/usblcd.c           |    8 ++++----
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 82e1663..aecf380 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -650,7 +650,7 @@ static int ftdi_elan_open(struct inode *inode, struct file *file)
 
 static int ftdi_elan_release(struct inode *inode, struct file *file)
 {
-        struct usb_ftdi *ftdi = (struct usb_ftdi *)file->private_data;
+        struct usb_ftdi *ftdi = file->private_data;
         if (ftdi == NULL)
                 return -ENODEV;
         up(&ftdi->sw_lock);        /* decrement the count on our device */
@@ -673,7 +673,7 @@ static ssize_t ftdi_elan_read(struct file *file, char __user *buffer,
         int bytes_read = 0;
         int retry_on_empty = 10;
         int retry_on_timeout = 5;
-        struct usb_ftdi *ftdi = (struct usb_ftdi *)file->private_data;
+        struct usb_ftdi *ftdi = file->private_data;
         if (ftdi->disconnected > 0) {
                 return -ENODEV;
         }
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 7dc9d3c..e81ac00 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -282,7 +282,7 @@ static ssize_t iowarrior_read(struct file *file, char __user *buffer,
 	int read_idx;
 	int offset;
 
-	dev = (struct iowarrior *)file->private_data;
+	dev = file->private_data;
 
 	/* verify that the device wasn't unplugged */
 	if (dev == NULL || !dev->present)
@@ -348,7 +348,7 @@ static ssize_t iowarrior_write(struct file *file,
 	char *buf = NULL;	/* for IOW24 and IOW56 we need a buffer */
 	struct urb *int_out_urb = NULL;
 
-	dev = (struct iowarrior *)file->private_data;
+	dev = file->private_data;
 
 	mutex_lock(&dev->mutex);
 	/* verify that the device wasn't unplugged */
@@ -483,7 +483,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 	int retval;
 	int io_res;		/* checks for bytes read/written and copy_to/from_user results */
 
-	dev = (struct iowarrior *)file->private_data;
+	dev = file->private_data;
 	if (dev == NULL) {
 		return -ENODEV;
 	}
@@ -656,7 +656,7 @@ static int iowarrior_release(struct inode *inode, struct file *file)
 	struct iowarrior *dev;
 	int retval = 0;
 
-	dev = (struct iowarrior *)file->private_data;
+	dev = file->private_data;
 	if (dev == NULL) {
 		return -ENODEV;
 	}
diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 8547bf9..6482c6e 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -448,7 +448,7 @@ static int tower_release (struct inode *inode, struct file *file)
 
 	dbg(2, "%s: enter", __func__);
 
-	dev = (struct lego_usb_tower *)file->private_data;
+	dev = file->private_data;
 
 	if (dev == NULL) {
 		dbg(1, "%s: object is NULL", __func__);
@@ -597,7 +597,7 @@ static ssize_t tower_read (struct file *file, char __user *buffer, size_t count,
 
 	dbg(2, "%s: enter, count = %Zd", __func__, count);
 
-	dev = (struct lego_usb_tower *)file->private_data;
+	dev = file->private_data;
 
 	/* lock this object */
 	if (mutex_lock_interruptible(&dev->lock)) {
@@ -686,7 +686,7 @@ static ssize_t tower_write (struct file *file, const char __user *buffer, size_t
 
 	dbg(2, "%s: enter, count = %Zd", __func__, count);
 
-	dev = (struct lego_usb_tower *)file->private_data;
+	dev = file->private_data;
 
 	/* lock this object */
 	if (mutex_lock_interruptible(&dev->lock)) {
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 30d9303..045120e 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -2486,7 +2486,7 @@ sisusb_release(struct inode *inode, struct file *file)
 {
 	struct sisusb_usb_data *sisusb;
 
-	if (!(sisusb = (struct sisusb_usb_data *)file->private_data))
+	if (!(sisusb = file->private_data))
 		return -ENODEV;
 
 	mutex_lock(&sisusb->lock);
@@ -2518,7 +2518,7 @@ sisusb_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 	u16 buf16;
 	u32 buf32, address;
 
-	if (!(sisusb = (struct sisusb_usb_data *)file->private_data))
+	if (!(sisusb = file->private_data))
 		return -ENODEV;
 
 	mutex_lock(&sisusb->lock);
@@ -2660,7 +2660,7 @@ sisusb_write(struct file *file, const char __user *buffer, size_t count,
 	u16 buf16;
 	u32 buf32, address;
 
-	if (!(sisusb = (struct sisusb_usb_data *)file->private_data))
+	if (!(sisusb = file->private_data))
 		return -ENODEV;
 
 	mutex_lock(&sisusb->lock);
@@ -2803,7 +2803,7 @@ sisusb_lseek(struct file *file, loff_t offset, int orig)
 	struct sisusb_usb_data *sisusb;
 	loff_t ret;
 
-	if (!(sisusb = (struct sisusb_usb_data *)file->private_data))
+	if (!(sisusb = file->private_data))
 		return -ENODEV;
 
 	mutex_lock(&sisusb->lock);
@@ -2968,7 +2968,7 @@ sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	long retval = 0;
 	u32 __user *argp = (u32 __user *)arg;
 
-	if (!(sisusb = (struct sisusb_usb_data *)file->private_data))
+	if (!(sisusb = file->private_data))
 		return -ENODEV;
 
 	mutex_lock(&sisusb->lock);
diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 7828c76..a0dad56 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -116,7 +116,7 @@ static int lcd_release(struct inode *inode, struct file *file)
 {
 	struct usb_lcd *dev;
 
-	dev = (struct usb_lcd *)file->private_data;
+	dev = file->private_data;
 	if (dev == NULL)
 		return -ENODEV;
 
@@ -132,7 +132,7 @@ static ssize_t lcd_read(struct file *file, char __user * buffer, size_t count, l
 	int retval = 0;
 	int bytes_read;
 
-	dev = (struct usb_lcd *)file->private_data;
+	dev = file->private_data;
 
 	/* do a blocking bulk read to get data from the device */
 	retval = usb_bulk_msg(dev->udev, 
@@ -158,7 +158,7 @@ static long lcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	u16 bcdDevice;
 	char buf[30];
 
-	dev = (struct usb_lcd *)file->private_data;
+	dev = file->private_data;
 	if (dev == NULL)
 		return -ENODEV;
 	
@@ -217,7 +217,7 @@ static ssize_t lcd_write(struct file *file, const char __user * user_buffer, siz
 	struct urb *urb = NULL;
 	char *buf = NULL;
 	
-	dev = (struct usb_lcd *)file->private_data;
+	dev = file->private_data;
 	
 	/* verify that we actually have some data to write */
 	if (count == 0)
-- 
1.7.1.337.g6068.dirty

