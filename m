Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0GLU6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:58:18 -0400
Received: from mail.perches.com ([173.55.12.10]:1715 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab0GLUub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:31 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 01/36] arch/cris: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:49:53 -0700
Message-Id: <a1f59726c5cbe63473fcd10e7a3ec5980adc9155.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/cris/arch-v32/drivers/mach-fs/gpio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
index d89ab80..9939857 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -185,7 +185,7 @@ static volatile unsigned long *dir_oe[NUM_PORTS] = {
 static unsigned int gpio_poll(struct file *file, struct poll_table_struct *wait)
 {
 	unsigned int mask = 0;
-	struct gpio_private *priv = (struct gpio_private *)file->private_data;
+	struct gpio_private *priv = file->private_data;
 	unsigned long data;
 	poll_wait(file, &priv->alarm_wq, wait);
 	if (priv->minor == GPIO_MINOR_A) {
@@ -353,7 +353,7 @@ gpio_pa_interrupt(int irq, void *dev_id)
 static ssize_t gpio_write(struct file *file, const char *buf, size_t count,
 	loff_t *off)
 {
-	struct gpio_private *priv = (struct gpio_private *)file->private_data;
+	struct gpio_private *priv = file->private_data;
 	unsigned char data, clk_mask, data_mask, write_msb;
 	unsigned long flags;
 	unsigned long shadow;
@@ -468,7 +468,7 @@ gpio_release(struct inode *inode, struct file *filp)
 
 	spin_lock_irq(&alarm_lock);
 	p = alarmlist;
-	todel = (struct gpio_private *)filp->private_data;
+	todel = filp->private_data;
 
 	if (p == todel) {
 		alarmlist = todel->next;
@@ -567,7 +567,7 @@ gpio_ioctl(struct inode *inode, struct file *file,
 	unsigned long flags;
 	unsigned long val;
 	unsigned long shadow;
-	struct gpio_private *priv = (struct gpio_private *)file->private_data;
+	struct gpio_private *priv = file->private_data;
 	if (_IOC_TYPE(cmd) != ETRAXGPIO_IOCTYPE)
 		return -EINVAL;
 
@@ -714,7 +714,7 @@ virtual_gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	unsigned long flags;
 	unsigned short val;
 	unsigned short shadow;
-	struct gpio_private *priv = (struct gpio_private *)file->private_data;
+	struct gpio_private *priv = file->private_data;
 
 	switch (_IOC_NR(cmd)) {
 	case IO_SETBITS:
-- 
1.7.1.337.g6068.dirty

