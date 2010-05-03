Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab0ECPsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:48:15 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42451 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529Ab0ECPsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:48:10 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Alexandre Bounine <alexandre.bounine@idt.com>,
       Matt Porter <mporter@kernel.crashing.org>,
       Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
       Thomas Moll <thomas.moll@sysgo.com>
Subject: [PATCH -mm 2/5] RapidIO: Add debug configuration option
Date: Mon,  3 May 2010 11:45:55 -0400
Message-Id: <1272901558-9292-3-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
References: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debug configuration option for RapidIO subsystem.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Thomas Moll <thomas.moll@sysgo.com>
---
 drivers/rapidio/Kconfig           |   11 +++++++++++
 drivers/rapidio/Makefile          |    4 ++++
 drivers/rapidio/switches/Makefile |    4 ++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/rapidio/Kconfig b/drivers/rapidio/Kconfig
index bcb5c20..070211a 100644
--- a/drivers/rapidio/Kconfig
+++ b/drivers/rapidio/Kconfig
@@ -21,3 +21,14 @@ config RAPIDIO_ENABLE_RX_TX_PORTS
 	  than Maintenance transfers.
 
 source "drivers/rapidio/switches/Kconfig"
+
+config RAPIDIO_DEBUG
+	bool "RapidIO subsystem debug messages"
+	depends on RAPIDIO
+	help
+	  Say Y here if you want the RapidIO subsystem to produce a bunch of
+	  debug messages to the system log. Select this if you are having a
+	  problem with the RapidIO subsystem and want to see more of what is
+	  going on.
+
+	  If you are unsure about this, say N here.
diff --git a/drivers/rapidio/Makefile b/drivers/rapidio/Makefile
index 7c0e181..b6139fe 100644
--- a/drivers/rapidio/Makefile
+++ b/drivers/rapidio/Makefile
@@ -4,3 +4,7 @@
 obj-y += rio.o rio-access.o rio-driver.o rio-scan.o rio-sysfs.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
+
+ifeq ($(CONFIG_RAPIDIO_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
diff --git a/drivers/rapidio/switches/Makefile b/drivers/rapidio/switches/Makefile
index 0fece0e..fe4adc3 100644
--- a/drivers/rapidio/switches/Makefile
+++ b/drivers/rapidio/switches/Makefile
@@ -6,3 +6,7 @@ obj-$(CONFIG_RAPIDIO_TSI57X)	+= tsi57x.o
 obj-$(CONFIG_RAPIDIO_CPS_XX)	+= idtcps.o
 obj-$(CONFIG_RAPIDIO_TSI568)	+= tsi568.o
 obj-$(CONFIG_RAPIDIO_TSI500)	+= tsi500.o
+
+ifeq ($(CONFIG_RAPIDIO_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
-- 
1.7.0.5

