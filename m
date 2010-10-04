Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab0JDIqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:46:16 -0400
Received: from vps.mortis.eu ([79.99.135.181]:42929 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab0JDIqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:46:15 -0400
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: Mike Hommey <mh@glandium.org>, Debian Bug #597820 <597820@bugs.debian.org>,
        Giel van Schijndel <me@mortis.eu>, Wim Van Sebroeck <wim@iguana.be>,
        Ralf Baechle <ralf@linux-mips.org>, dann frazier <dannf@hp.com>,
        Tony Lindgren <tony@atomide.com>, linux-watchdog@vger.kernel.org
Subject: [PATCH] watchdog: f71808e_wdt: add support for the F71889FG
Date: Mon,  4 Oct 2010 10:45:28 +0200
Message-Id: <1286181928-4010-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 drivers/watchdog/Kconfig       |    4 ++--
 drivers/watchdog/f71808e_wdt.c |   10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 24efd8e..0fcbb87 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -409,11 +409,11 @@ config ALIM7101_WDT
 	  Most people will say N.
 
 config F71808E_WDT
-	tristate "Fintek F71808E and F71882FG Watchdog"
+	tristate "Fintek F71808E, F71882FG and F71889FG Watchdog"
 	depends on X86 && EXPERIMENTAL
 	help
 	  This is the driver for the hardware watchdog on the Fintek
-	  F71808E and F71882FG Super I/O controllers.
+	  F71808E, F71882FG and F71889FG Super I/O controllers.
 
 	  You can compile this driver directly into the kernel, or use
 	  it as a module.  The module will be called f71808e_wdt.
diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index 7e5c266..65e5796 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -308,6 +308,12 @@ static int watchdog_start(void)
 		superio_set_bit(watchdog.sioaddr, 0x29, 1);
 		break;
 
+	case f71889fg:
+		/* set pin 40 to WDTRST# */
+		superio_outb(watchdog.sioaddr, 0x2b,
+				superio_inb(watchdog.sioaddr, 0x2b) & 0xcf);
+		break;
+
 	default:
 		/*
 		 * 'default' label to shut up the compiler and catch
@@ -708,8 +714,10 @@ static int __init f71808e_find(int sioaddr)
 	case SIO_F71882_ID:
 		watchdog.type = f71882fg;
 		break;
-	case SIO_F71862_ID:
 	case SIO_F71889_ID:
+		watchdog.type = f71889fg;
+		break;
+	case SIO_F71862_ID:
 		/* These have a watchdog, though it isn't implemented (yet). */
 		err = -ENOSYS;
 		goto exit;
-- 
1.6.4.4

