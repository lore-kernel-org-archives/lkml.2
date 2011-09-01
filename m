Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1IAF7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 01:59:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52781 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab1IAF7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 01:59:31 -0400
From: WANG Cong <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-cris-kernel@axis.com, linux-serial@vger.kernel.org
Subject: [PATCH] cris: fix a build error in drivers/tty/serial/crisv10.c
Date: Thu,  1 Sep 2011 13:58:29 +0800
Message-Id: <1314856709-5766-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

drivers/tty/serial/crisv10.c:4453: error: 'if_ser0' undeclared (first use in this function): 2 errors in 2 logs
        v3.1-rc4/cris/cris-allmodconfig v3.1-rc4/cris/cris-allyesconfig
drivers/tty/serial/crisv10.c:4453: error: (Each undeclared identifier is reported only once: 2 errors in 2 logs
        v3.1-rc4/cris/cris-allmodconfig v3.1-rc4/cris/cris-allyesconfig
drivers/tty/serial/crisv10.c:4453: error: for each function it appears in.): 2 errors in 2 logs
        v3.1-rc4/cris/cris-allmodconfig v3.1-rc4/cris/cris-allyesconfig

"if_ser0" is a typo, it should be "if_serial_0".

Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 225123b..58be715 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -4450,7 +4450,7 @@ static int __init rs_init(void)
 
 #if defined(CONFIG_ETRAX_RS485)
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
-	if (cris_io_interface_allocate_pins(if_ser0, 'a', rs485_pa_bit,
+	if (cris_io_interface_allocate_pins(if_serial_0, 'a', rs485_pa_bit,
 			rs485_pa_bit)) {
 		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
@@ -4459,7 +4459,7 @@ static int __init rs_init(void)
 	}
 #endif
 #if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
-	if (cris_io_interface_allocate_pins(if_ser0, 'g', rs485_pa_bit,
+	if (cris_io_interface_allocate_pins(if_serial_0, 'g', rs485_pa_bit,
 			rs485_port_g_bit)) {
 		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
