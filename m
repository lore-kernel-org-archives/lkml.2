Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab1KJDUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:20:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1KJDUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:20:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:00 2011
Message-Id: <20111109212700.616888037@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        WANG Cong <xiyou.wangcong@gmail.com>
Subject: [003/262] cris: fix a build error in drivers/tty/serial/crisv10.c
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WANG Cong <xiyou.wangcong@gmail.com>

commit 2f7861de111bb8e33e6ab9f9607583c6fbc00132 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/crisv10.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


