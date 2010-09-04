Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0IDCNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:13:35 -0400
Received: from kroah.org ([198.145.64.141]:48232 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab0IDCNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:13:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Philippe Langlais <philippe.langlais@stericsson.com>,
        stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] serial: fix port type conflict between NS16550A & U6_16550A
Date: Fri,  3 Sep 2010 19:13:20 -0700
Message-Id: <1283566402-28832-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100904020937.GA28645@kroah.com>
References: <20100904020937.GA28645@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@stericsson.com>

Bug seen by Dr. David Alan Gilbert with sparse

Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/serial.h      |    3 +--
 include/linux/serial_core.h |    3 ++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/serial.h b/include/linux/serial.h
index 1ebc694..ef91406 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -77,8 +77,7 @@ struct serial_struct {
 #define PORT_16654	11
 #define PORT_16850	12
 #define PORT_RSA	13	/* RSA-DV II/S card */
-#define PORT_U6_16550A	14
-#define PORT_MAX	14
+#define PORT_MAX	13
 
 #define SERIAL_IO_PORT	0
 #define SERIAL_IO_HUB6	1
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 64458a9..563e234 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -44,7 +44,8 @@
 #define PORT_RM9000	16	/* PMC-Sierra RM9xxx internal UART */
 #define PORT_OCTEON	17	/* Cavium OCTEON internal UART */
 #define PORT_AR7	18	/* Texas Instruments AR7 internal UART */
-#define PORT_MAX_8250	18	/* max port ID */
+#define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
+#define PORT_MAX_8250	19	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
-- 
1.7.2

