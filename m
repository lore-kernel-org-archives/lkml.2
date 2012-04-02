Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2DBL45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:57 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48196 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab2DBLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 54/69] TTY: 68328serial, use ulong flags for interrupts status
Date: Mon,  2 Apr 2012 13:54:38 +0200
Message-Id: <1333367693-3244-55-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flags passed to local_irq_save/restore should be ulong. Switch tehem
to that. Otherwise we get compilation warnings:
.../68328serial.c:248:9: warning: comparison of distinct pointer types lacks a cast [enabled by default]
.../68328serial.c:257:9: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 drivers/tty/serial/68328serial.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 81ed91e..f0d5039 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -162,7 +162,8 @@ static void rs_stop(struct tty_struct *tty)
 
 static int rs_put_char(char ch)
 {
-        int flags, loops = 0;
+	unsigned long flags;
+	int loops = 0;
 
         local_irq_save(flags);
 
@@ -1182,7 +1183,8 @@ static const struct tty_operations rs_ops = {
 static int __init
 rs68328_init(void)
 {
-	int flags, i;
+	unsigned long flags;
+	int i;
 	struct m68k_serial *info;
 
 	serial_driver = alloc_tty_driver(NR_PORTS);
-- 
1.7.9.2


