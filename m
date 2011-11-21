Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1KUN5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:57:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49395 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1KUN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:56:34 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv1 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory Drivers
Date: Mon, 21 Nov 2011 14:56:03 +0100
Message-Id: <1321883764-1958-9-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321883764-1958-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1321883764-1958-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/Kconfig       |    2 ++
 drivers/Makefile      |    1 +
 drivers/xshm/Kconfig  |   10 ++++++++++
 drivers/xshm/Makefile |    4 ++++
 4 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xshm/Kconfig
 create mode 100644 drivers/xshm/Makefile

diff --git a/drivers/Kconfig b/drivers/Kconfig
index b5e6f24..c91a13c 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -136,4 +136,6 @@ source "drivers/hv/Kconfig"
 
 source "drivers/devfreq/Kconfig"
 
+source "drivers/xshm/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 1b31421..eedd8e5 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -120,6 +120,7 @@ obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
 obj-y				+= ieee802154/
+obj-$(CONFIG_XSHM)		+= xshm/
 #common clk code
 obj-y				+= clk/
 
diff --git a/drivers/xshm/Kconfig b/drivers/xshm/Kconfig
new file mode 100644
index 0000000..fa627b8
--- /dev/null
+++ b/drivers/xshm/Kconfig
@@ -0,0 +1,10 @@
+config XSHM
+	tristate "External Shared Memory Protocol (XSHM)"
+#	depends on GENIO
+	default n
+	---help---
+	Say "yes" if you want to support External Shared Memory (XSHM)
+	IPC mechanism. XSHM is an IPC protocol used to talk to external
+	device such as modem over a shared memory (e.g. Chip to Chip).
+	This will normally be built-in, loadable module is used for testing.
+	If unsure say N.
diff --git a/drivers/xshm/Makefile b/drivers/xshm/Makefile
new file mode 100644
index 0000000..a630501
--- /dev/null
+++ b/drivers/xshm/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_XSHM) +=  xshmchr.o
+xshmchr-objs := xshm_chr.o
+obj-$(CONFIG_XSHM) += xshm.o
+xshm-objs := xshm_boot.o xshm_pdev.o genio_dummy.o
-- 
1.7.1

