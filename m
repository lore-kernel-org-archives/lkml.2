Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1IAGOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:14:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36731 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab1IAGOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:14:45 -0400
From: WANG Cong <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-cris-kernel@axis.com, linux-serial@vger.kernel.org
Subject: [PATCH] cris: lower the printk level in cris serial driver
Date: Thu,  1 Sep 2011 14:14:00 +0800
Message-Id: <1314857640-6623-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERN_CRIT is too high, replace those KERN_CRIT with KERN_ERR or KERN_INFO.

Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 225123b..77ba4ed 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -1788,7 +1788,7 @@ static unsigned int handle_descr_data(struct e100_serial *info,
 	struct etrax_recv_buffer *buffer = phys_to_virt(descr->buf) - sizeof *buffer;
 
 	if (info->recv_cnt + recvl > 65536) {
-		printk(KERN_CRIT
+		printk(KERN_INFO
 		       "%s: Too much pending incoming serial data! Dropping %u bytes.\n", __func__, recvl);
 		return 0;
 	}
@@ -3813,13 +3813,13 @@ rs_close(struct tty_struct *tty, struct file * filp)
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
-		printk(KERN_CRIT
+		printk(KERN_ERR
 		       "rs_close: bad serial port count; tty->count is 1, "
 		       "info->count is %d\n", info->count);
 		info->count = 1;
 	}
 	if (--info->count < 0) {
-		printk(KERN_CRIT "rs_close: bad serial port count for ttyS%d: %d\n",
+		printk(KERN_ERR "rs_close: bad serial port count for ttyS%d: %d\n",
 		       info->line, info->count);
 		info->count = 0;
 	}
@@ -4452,7 +4452,7 @@ static int __init rs_init(void)
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
 	if (cris_io_interface_allocate_pins(if_ser0, 'a', rs485_pa_bit,
 			rs485_pa_bit)) {
-		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
+		printk(KERN_ERR "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
 		put_tty_driver(driver);
 		return -EBUSY;
@@ -4461,7 +4461,7 @@ static int __init rs_init(void)
 #if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
 	if (cris_io_interface_allocate_pins(if_ser0, 'g', rs485_pa_bit,
 			rs485_port_g_bit)) {
-		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
+		printk(KERN_ERR "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
 		put_tty_driver(driver);
 		return -EBUSY;
@@ -4494,7 +4494,7 @@ static int __init rs_init(void)
 		if (info->enabled) {
 			if (cris_request_io_interface(info->io_if,
 					info->io_if_description)) {
-				printk(KERN_CRIT "ETRAX100LX async serial: "
+				printk(KERN_ERR "ETRAX100LX async serial: "
 					"Could not allocate IO pins for "
 					"%s, port %d\n",
 					info->io_if_description, i);
