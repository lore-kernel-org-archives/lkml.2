Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2HGT7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:59:07 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36536 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab2HGT7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 31/41] TTY: nfcon, add tty_port and link it
Date: Tue,  7 Aug 2012 21:47:56 +0200
Message-Id: <1344368886-24033-32-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every tty driver needs tty_port for each line. So let us add one to
nfcon too. And link it so that the tty layer knows about it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/emu/nfcon.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/m68k/emu/nfcon.c b/arch/m68k/emu/nfcon.c
index 8db25e8..16d170f 100644
--- a/arch/m68k/emu/nfcon.c
+++ b/arch/m68k/emu/nfcon.c
@@ -19,6 +19,7 @@
 #include <asm/natfeat.h>
 
 static int stderr_id;
+static struct tty_port nfcon_tty_port;
 static struct tty_driver *nfcon_tty_driver;
 
 static void nfputs(const char *str, unsigned int count)
@@ -119,6 +120,8 @@ static int __init nfcon_init(void)
 {
 	int res;
 
+	tty_port_init(&nfcon_tty_port);
+
 	stderr_id = nf_get_id("NF_STDERR");
 	if (!stderr_id)
 		return -ENODEV;
@@ -135,6 +138,7 @@ static int __init nfcon_init(void)
 	nfcon_tty_driver->flags = TTY_DRIVER_REAL_RAW;
 
 	tty_set_operations(nfcon_tty_driver, &nfcon_tty_ops);
+	tty_port_link_device(&nfcon_tty_port, nfcon_tty_driver, 0);
 	res = tty_register_driver(nfcon_tty_driver);
 	if (res) {
 		pr_err("failed to register nfcon tty driver\n");
-- 
1.7.10.4


