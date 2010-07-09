Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0GINuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:50:00 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50339 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab0GINt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:49:58 -0400
Date: Fri, 9 Jul 2010 15:49:56 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 06/11] Removing dead ETRAX_RS485_LTC1387
Message-ID: <e7dc4bbad66a5e85dc231e3e713a26a19098ff6a.1278682303.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ETRAX_RS485_LTC1387 doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/crisv10.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 426fed8..84e5357 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -1393,12 +1393,6 @@ e100_enable_rs485(struct tty_struct *tty, struct serial_rs485 *r)
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
 	*R_PORT_PA_DATA = port_pa_data_shadow |= (1 << rs485_pa_bit);
 #endif
-#if defined(CONFIG_ETRAX_RS485_LTC1387)
-	REG_SHADOW_SET(R_PORT_G_DATA, port_g_data_shadow,
-		       CONFIG_ETRAX_RS485_LTC1387_DXEN_PORT_G_BIT, 1);
-	REG_SHADOW_SET(R_PORT_G_DATA, port_g_data_shadow,
-		       CONFIG_ETRAX_RS485_LTC1387_RXEN_PORT_G_BIT, 1);
-#endif
 
 	info->rs485.flags = r->flags;
 	if (r->delay_rts_before_send >= 1000)
@@ -3860,12 +3854,6 @@ rs_close(struct tty_struct *tty, struct file * filp)
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
 		*R_PORT_PA_DATA = port_pa_data_shadow &= ~(1 << rs485_pa_bit);
 #endif
-#if defined(CONFIG_ETRAX_RS485_LTC1387)
-		REG_SHADOW_SET(R_PORT_G_DATA, port_g_data_shadow,
-			       CONFIG_ETRAX_RS485_LTC1387_DXEN_PORT_G_BIT, 0);
-		REG_SHADOW_SET(R_PORT_G_DATA, port_g_data_shadow,
-			       CONFIG_ETRAX_RS485_LTC1387_RXEN_PORT_G_BIT, 0);
-#endif
 	}
 #endif
 
-- 
1.7.0.4

