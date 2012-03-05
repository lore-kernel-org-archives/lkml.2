Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2CEOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:09:57 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34627 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab2CENxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 44/68] TTY: simserial no longer needs serialP
Date: Mon,  5 Mar 2012 14:52:31 +0100
Message-Id: <1330955575-26641-45-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's do a spin-off of serial_state structure with only needed
elements.

And remove serialP crap from includes.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |    9 ++++++++-
 include/linux/serialP.h      |    2 --
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 3698a2f..120aad4 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -27,10 +27,10 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/capability.h>
+#include <linux/circ_buf.h>
 #include <linux/console.h>
 #include <linux/module.h>
 #include <linux/serial.h>
-#include <linux/serialP.h>
 #include <linux/sysrq.h>
 
 #include <asm/irq.h>
@@ -46,6 +46,13 @@
 
 #define NR_PORTS	1	/* only one port for now */
 
+struct serial_state {
+	struct tty_port tport;
+	struct circ_buf xmit;
+	int irq;
+	int x_char;
+};
+
 static char *serial_name = "SimSerial driver";
 static char *serial_version = "0.6";
 
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index e5e8442..9a04dec 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -44,10 +44,8 @@ struct serial_state {
 	int			quot;
 	int			IER; 	/* Interrupt Enable Register */
 	int			MCR; 	/* Modem control register */
-	/* simserial */
 	int			x_char;	/* xon/xoff character */
  	struct circ_buf		xmit;
-	/* /simserial */
 	/* /amiserial */
 };
 
-- 
1.7.9.2


