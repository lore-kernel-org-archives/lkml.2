Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1JWVSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:18:25 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42423 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1JWVSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:18:24 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 3/5] m68k/serial: Remove obsolete IRQ_FLG_* users
Date: Sun, 23 Oct 2011 23:18:04 +0200
Message-Id: <1319404686-10800-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319404686-10800-1-git-send-email-geert@linux-m68k.org>
References: <1319404686-10800-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m68k core irq code stopped honoring these flags during the irq
restructuring in 2006.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
This is a split-up of "m68k/irq: Remove obsolete IRQ_FLG_* definitions and
users", to reduce conflicts and dependencies.

diff --git a/drivers/tty/serial/68360serial.c b/drivers/tty/serial/68360serial.c
index 0a3e878..daf0b1d 100644
--- a/drivers/staging/serial/68360serial.c
+++ b/drivers/staging/serial/68360serial.c
@@ -2771,8 +2771,8 @@ static int __init rs_360_init(void)
 			*/
 			/* cpm_install_handler(IRQ_MACHSPEC | state->irq, rs_360_interrupt, info);  */
 			/*request_irq(IRQ_MACHSPEC | state->irq, rs_360_interrupt, */
-			request_irq(state->irq, rs_360_interrupt,
-						IRQ_FLG_LOCK, "ttyS", (void *)info);
+			request_irq(state->irq, rs_360_interrupt, 0, "ttyS",
+				    (void *)info);
 
 			/* Set up the baud rate generator.
 			*/
-- 
1.7.0.4

