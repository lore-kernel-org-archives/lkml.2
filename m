Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965222Ab2CEOIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:08:55 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34639 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab2CENxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 42/68] TTY: simserial, remove tmp_buf
Date: Mon,  5 Mar 2012 14:52:29 +0100
Message-Id: <1330955575-26641-43-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is totally unused.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 64ab004..45df0f4 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -55,8 +55,6 @@ struct tty_driver *hp_simserial_driver;
 
 static struct console *console;
 
-static unsigned char *tmp_buf;
-
 extern struct console *console_drivers; /* from kernel/printk.c */
 
 /*
@@ -237,7 +235,8 @@ static int rs_write(struct tty_struct * tty,
 	int	c, ret = 0;
 	unsigned long flags;
 
-	if (!tty || !info->xmit.buf || !tmp_buf) return 0;
+	if (!tty || !info->xmit.buf)
+		return 0;
 
 	local_irq_save(flags);
 	while (1) {
@@ -618,7 +617,6 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 {
 	struct serial_state *info = rs_table + tty->index;
 	int			retval;
-	unsigned long		page;
 
 	info->tport.count++;
 	info->tport.tty = tty;
@@ -630,16 +628,6 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 #endif
 	tty->low_latency = (info->tport.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
-	if (!tmp_buf) {
-		page = get_zeroed_page(GFP_KERNEL);
-		if (!page)
-			return -ENOMEM;
-		if (tmp_buf)
-			free_page(page);
-		else
-			tmp_buf = (unsigned char *) page;
-	}
-
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
-- 
1.7.9.2


