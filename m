Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2A3Cu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:50:26 -0500
Received: from cronus.persephoneslair.org ([216.254.15.24]:58048 "EHLO
	cronus.persephoneslair.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011Ab2A3CuX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:50:23 -0500
Date: Sun, 29 Jan 2012 18:44:46 -0800
From: Andrea Shepard <andrea@persephoneslair.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: khc@pm.waw.pl, davem@davemloft.net, mmarek@suse.cz, jkosina@suse.cz,
        joe@perches.com, justinmattock@gmail.com, gregkh@suse.de,
        alan@linux.intel.com, jdmason@kudzu.us
Subject: [02/22] Cyclades PC300 driver: re-enable Kconfig option
Message-ID: <20120130024446.GC10262@cronus.persephoneslair.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old pc300 driver had been disabled because it did not build.  This patch
re-enables it in Kconfig.

Signed-off-by: Andrea Shepard <andrea@persephoneslair.org>

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 423eb26..36a439a 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -205,10 +205,8 @@ config WANXL_BUILD_FIRMWARE
 
 config PC300
 	tristate "Cyclades-PC300 support (RS-232/V.35, X.21, T1/E1 boards)"
-	depends on HDLC && PCI && BROKEN
+	depends on HDLC && PCI
 	---help---
-	  This driver is broken because of struct tty_driver change.
-
 	  Driver for the Cyclades-PC300 synchronous communication boards.
 
 	  These boards provide synchronous serial interfaces to your
@@ -217,6 +215,10 @@ config PC300
 	  option later and read the file README.mlppp provided by PC300
 	  package.
 
+          Due to changes in certain ioctls necessary for portability, this
+          version requires a new version of pc300utils, which may be found
+          at: http://charon.persephoneslair.org/~andrea/software/pc300utils/
+
 	  To compile this as a module, choose M here: the module
 	  will be called pc300.
 
@@ -228,11 +230,8 @@ config PC300_MLPPP
 	help
 	  Multilink PPP over the PC300 synchronous communication boards.
 
-comment "Cyclades-PC300 MLPPP support is disabled."
-	depends on HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
-
 comment "Refer to the file README.mlppp, provided by PC300 package."
-	depends on HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
+	depends on HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP) && PC300_MLPPP
 
 config PC300TOO
 	tristate "Cyclades PC300 RSV/X21 alternative support"
