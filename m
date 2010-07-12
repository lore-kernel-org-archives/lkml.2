Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0GLUy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:54:57 -0400
Received: from mail.perches.com ([173.55.12.10]:1760 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab0GLUuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:52 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH 18/36] drivers/staging: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:10 -0700
Message-Id: <4161b00d2e3611111f16c5a8c17fc013f0540e7d.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/batman-adv/bat_debugfs.c |    4 ++--
 drivers/staging/batman-adv/icmp_socket.c |   12 ++++--------
 drivers/staging/cx25821/cx25821-alsa.c   |    2 +-
 drivers/staging/easycap/easycap_ioctl.c  |    4 ++--
 drivers/staging/easycap/easycap_main.c   |    4 ++--
 drivers/staging/easycap/easycap_sound.c  |    2 +-
 6 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/batman-adv/bat_debugfs.c b/drivers/staging/batman-adv/bat_debugfs.c
index 8e8eef0..507da68 100644
--- a/drivers/staging/batman-adv/bat_debugfs.c
+++ b/drivers/staging/batman-adv/bat_debugfs.c
@@ -104,7 +104,7 @@ static int log_release(struct inode *inode, struct file *file)
 static ssize_t log_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	struct bat_priv *bat_priv = (struct bat_priv *)file->private_data;
+	struct bat_priv *bat_priv = file->private_data;
 	struct debug_log *debug_log = bat_priv->debug_log;
 	int error, i = 0;
 	char c;
@@ -158,7 +158,7 @@ static ssize_t log_read(struct file *file, char __user *buf,
 
 static unsigned int log_poll(struct file *file, poll_table *wait)
 {
-	struct bat_priv *bat_priv = (struct bat_priv *)file->private_data;
+	struct bat_priv *bat_priv = file->private_data;
 	struct debug_log *debug_log = bat_priv->debug_log;
 
 	poll_wait(file, &debug_log->queue_wait, wait);
diff --git a/drivers/staging/batman-adv/icmp_socket.c b/drivers/staging/batman-adv/icmp_socket.c
index 532f246..fc3d32c 100644
--- a/drivers/staging/batman-adv/icmp_socket.c
+++ b/drivers/staging/batman-adv/icmp_socket.c
@@ -78,8 +78,7 @@ static int bat_socket_open(struct inode *inode, struct file *file)
 
 static int bat_socket_release(struct inode *inode, struct file *file)
 {
-	struct socket_client *socket_client =
-		(struct socket_client *)file->private_data;
+	struct socket_client *socket_client = file->private_data;
 	struct socket_packet *socket_packet;
 	struct list_head *list_pos, *list_pos_tmp;
 	unsigned long flags;
@@ -107,8 +106,7 @@ static int bat_socket_release(struct inode *inode, struct file *file)
 static ssize_t bat_socket_read(struct file *file, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
-	struct socket_client *socket_client =
-		(struct socket_client *)file->private_data;
+	struct socket_client *socket_client = file->private_data;
 	struct socket_packet *socket_packet;
 	size_t packet_len;
 	int error;
@@ -155,8 +153,7 @@ static ssize_t bat_socket_write(struct file *file, const char __user *buff,
 {
 	/* FIXME: each orig_node->batman_if will be attached to a softif */
 	struct bat_priv *bat_priv = netdev_priv(soft_device);
-	struct socket_client *socket_client =
-		(struct socket_client *)file->private_data;
+	struct socket_client *socket_client = file->private_data;
 	struct icmp_packet_rr icmp_packet;
 	struct orig_node *orig_node;
 	struct batman_if *batman_if;
@@ -247,8 +244,7 @@ out:
 
 static unsigned int bat_socket_poll(struct file *file, poll_table *wait)
 {
-	struct socket_client *socket_client =
-		(struct socket_client *)file->private_data;
+	struct socket_client *socket_client = file->private_data;
 
 	poll_wait(file, &socket_client->queue_wait, wait);
 
diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index a43b188..bbe3643 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -698,7 +698,7 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 
 	/* Card "creation" */
 	card->private_free = snd_cx25821_dev_free;
-	chip = (struct cx25821_audio_dev *) card->private_data;
+	chip = card->private_data;
 	spin_lock_init(&chip->reg_lock);
 
 	chip->dev = dev;
diff --git a/drivers/staging/easycap/easycap_ioctl.c b/drivers/staging/easycap/easycap_ioctl.c
index f71cd9e..a36a8e8 100644
--- a/drivers/staging/easycap/easycap_ioctl.c
+++ b/drivers/staging/easycap/easycap_ioctl.c
@@ -791,7 +791,7 @@ static struct easycap *peasycap;
 static struct usb_device *p;
 static __u32 isequence;
 
-peasycap = (struct easycap *)file->private_data;
+peasycap = file->private_data;
 if (NULL == peasycap) {
 	SAY("ERROR:  peasycap is NULL\n");
 	return -1;
@@ -1972,7 +1972,7 @@ int easysnd_ioctl(struct inode *inode, struct file *file, \
 struct easycap *peasycap;
 struct usb_device *p;
 
-peasycap = (struct easycap *)file->private_data;
+peasycap = file->private_data;
 if (NULL == peasycap) {
 	SAY("ERROR:  peasycap is NULL.\n");
 	return -1;
diff --git a/drivers/staging/easycap/easycap_main.c b/drivers/staging/easycap/easycap_main.c
index 18259df..8724b4a 100644
--- a/drivers/staging/easycap/easycap_main.c
+++ b/drivers/staging/easycap/easycap_main.c
@@ -531,7 +531,7 @@ struct easycap *peasycap;
 
 JOT(4, "\n");
 
-peasycap = (struct easycap *)file->private_data;
+peasycap = file->private_data;
 if (NULL == peasycap) {
 	SAY("ERROR:  peasycap is NULL.\n");
 	SAY("ending unsuccessfully\n");
@@ -823,7 +823,7 @@ if (NULL == ((struct file *)file)) {
 	SAY("ERROR:  file pointer is NULL\n");
 	return -EFAULT;
 }
-peasycap = (struct easycap *)file->private_data;
+peasycap = file->private_data;
 if (NULL == peasycap) {
 	SAY("ERROR:  peasycap is NULL\n");
 	return -EFAULT;
diff --git a/drivers/staging/easycap/easycap_sound.c b/drivers/staging/easycap/easycap_sound.c
index 532c410..b0fc517 100644
--- a/drivers/staging/easycap/easycap_sound.c
+++ b/drivers/staging/easycap/easycap_sound.c
@@ -563,7 +563,7 @@ struct easycap *peasycap;
 
 JOT(4, "begins\n");
 
-peasycap = (struct easycap *)file->private_data;
+peasycap = file->private_data;
 if (NULL == peasycap) {
 	SAY("ERROR:  peasycap is NULL.\n");
 	return -EFAULT;
-- 
1.7.1.337.g6068.dirty

