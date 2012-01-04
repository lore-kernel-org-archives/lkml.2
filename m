Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2ADUQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:16:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:40829 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab2ADUQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:16:28 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: alan@linux.intel.com, gregkh@suse.de
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: driver for m32 arch should not have DEC alpha errata
Date: Wed,  4 Jan 2012 15:16:24 -0500
Message-Id: <1325708184-9861-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was copied from the original 8250 driver and hence
got the DEC alpha errata workaround.  But the workaround is ugly
and we don't really want it in any more places than it absolutely
needs to be.  Obviously ARCH=m32r means ARCH != alpha, so just
remove the references to the ALPHA_KLUDGE_MCR define.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index 0801893..94a6792 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -1000,11 +1000,8 @@ static void __init m32r_sio_register_ports(struct uart_driver *drv)
 		init_timer(&up->timer);
 		up->timer.function = m32r_sio_timeout;
 
-		/*
-		 * ALPHA_KLUDGE_MCR needs to be killed.
-		 */
-		up->mcr_mask = ~ALPHA_KLUDGE_MCR;
-		up->mcr_force = ALPHA_KLUDGE_MCR;
+		up->mcr_mask = ~0;
+		up->mcr_force = 0;
 
 		uart_add_one_port(drv, &up->port);
 	}
-- 
1.7.7

