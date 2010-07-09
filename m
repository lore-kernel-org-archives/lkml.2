Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0GINtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:49:47 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50317 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab0GINtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:49:45 -0400
Date: Fri, 9 Jul 2010 15:49:43 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 05/11] Removing dead ETRAX_RS485_ON_PORT_G
Message-ID: <28599787e744c7206e32497dfffbaef1fe8d905b.1278682302.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ETRAX_RS485_ON_PORT_G doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/crisv10.c |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 31f1723..426fed8 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -57,10 +57,6 @@ static char *serial_version = "$Revision: 1.25 $";
 #error "RX_TIMEOUT_TICKS == 0 not allowed, use 1"
 #endif
 
-#if defined(CONFIG_ETRAX_RS485_ON_PA) && defined(CONFIG_ETRAX_RS485_ON_PORT_G)
-#error "Disable either CONFIG_ETRAX_RS485_ON_PA or CONFIG_ETRAX_RS485_ON_PORT_G"
-#endif
-
 /*
  * All of the compatibilty code so we can compile serial.c against
  * older kernels is hidden in serial_compat.h
@@ -495,9 +491,6 @@ static struct fast_timer fast_timers_rs485[NR_PORTS];
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
 static int rs485_pa_bit = CONFIG_ETRAX_RS485_ON_PA_BIT;
 #endif
-#if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
-static int rs485_port_g_bit = CONFIG_ETRAX_RS485_ON_PORT_G_BIT;
-#endif
 #endif
 
 /* Info and macros needed for each ports extra control/status signals. */
@@ -1400,10 +1393,6 @@ e100_enable_rs485(struct tty_struct *tty, struct serial_rs485 *r)
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
 	*R_PORT_PA_DATA = port_pa_data_shadow |= (1 << rs485_pa_bit);
 #endif
-#if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
-	REG_SHADOW_SET(R_PORT_G_DATA,  port_g_data_shadow,
-		       rs485_port_g_bit, 1);
-#endif
 #if defined(CONFIG_ETRAX_RS485_LTC1387)
 	REG_SHADOW_SET(R_PORT_G_DATA, port_g_data_shadow,
 		       CONFIG_ETRAX_RS485_LTC1387_DXEN_PORT_G_BIT, 1);
@@ -3871,10 +3860,6 @@ rs_close(struct tty_struct *tty, struct file * filp)
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
 		*R_PORT_PA_DATA = port_pa_data_shadow &= ~(1 << rs485_pa_bit);
 #endif
-#if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
-		REG_SHADOW_SET(R_PORT_G_DATA, port_g_data_shadow,
-			       rs485_port_g_bit, 0);
-#endif
 #if defined(CONFIG_ETRAX_RS485_LTC1387)
 		REG_SHADOW_SET(R_PORT_G_DATA, port_g_data_shadow,
 			       CONFIG_ETRAX_RS485_LTC1387_DXEN_PORT_G_BIT, 0);
@@ -4443,15 +4428,6 @@ static int __init rs_init(void)
 		return -EBUSY;
 	}
 #endif
-#if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
-	if (cris_io_interface_allocate_pins(if_ser0, 'g', rs485_pa_bit,
-			rs485_port_g_bit)) {
-		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
-			"RS485 pin\n");
-		put_tty_driver(driver);
-		return -EBUSY;
-	}
-#endif
 #endif
 
 	/* Initialize the tty_driver structure */
-- 
1.7.0.4

