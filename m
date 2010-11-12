Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab0KLVlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:41:25 -0500
Received: from kroah.org ([198.145.64.141]:41595 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080Ab0KLVlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/19] serial: bfin_5xx: disable CON_PRINTBUFFER for consoles
Date: Fri, 12 Nov 2010 13:41:03 -0800
Message-Id: <1289598066-10112-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

If we are using early serial, don't let the normal console rewind
the log buffer, since that causes things to be printed multiple times.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_5xx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index a454e42..9655321 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1324,6 +1324,14 @@ struct console __init *bfin_earlyserial_init(unsigned int port,
 	struct bfin_serial_port *uart;
 	struct ktermios t;
 
+#ifdef CONFIG_SERIAL_BFIN_CONSOLE
+	/*
+	 * If we are using early serial, don't let the normal console rewind
+	 * log buffer, since that causes things to be printed multiple times
+	 */
+	bfin_serial_console.flags &= ~CON_PRINTBUFFER;
+#endif
+
 	if (port == -1 || port >= nr_active_ports)
 		port = 0;
 	bfin_serial_init_ports();
-- 
1.7.1

