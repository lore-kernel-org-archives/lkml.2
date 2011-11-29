Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1K2Tjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:39:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34223 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab1K2Tjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:39:48 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, sjurbren@gmail.com,
        Paul Bolle <pebolle@tiscali.nl>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory Drivers
Date: Tue, 29 Nov 2011 20:39:09 +0100
Message-Id: <1322595550-6473-9-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---

Changes from RFCv2. These are pointed out by Paul Bolle:
o Replaced comment with proper dependency to C2C_DRIVER driver
o Fixed unnecessary name-change for xshm_chr
o Introduced CONFIG_XSHM_CHR that automatically selects CONFIG_XSHM

 drivers/Kconfig       |    2 ++
 drivers/Makefile      |    1 +
 drivers/xshm/Kconfig  |   17 +++++++++++++++++
 drivers/xshm/Makefile |    3 +++
 4 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xshm/Kconfig
 create mode 100644 drivers/xshm/Makefile

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 041426c..742f028 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -138,4 +138,6 @@ source "drivers/virt/Kconfig"
 
 source "drivers/devfreq/Kconfig"
 
+source "drivers/xshm/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 91077ac..30eae54 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -121,6 +121,7 @@ obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
 obj-y				+= ieee802154/
+obj-$(CONFIG_XSHM)		+= xshm/
 #common clk code
 obj-y				+= clk/
 
diff --git a/drivers/xshm/Kconfig b/drivers/xshm/Kconfig
new file mode 100644
index 0000000..bae0da2
--- /dev/null
+++ b/drivers/xshm/Kconfig
@@ -0,0 +1,17 @@
+# XSHM gets selected by whoever wants it.
+config XSHM
+	depends on CONFIG_C2C
+	tristate
+
+config XSHM_CHR
+	tristate "Character device for External Shared Memory (XSHM)"
+	select XSHM
+	default n
+	---help---
+	Say "Y" if you want to character device for External Shared
+	Memory (XSHM) IPC mechanism. XSHM is an IPC protocol used to
+	talk to external device such as modem over a shared memory
+	(e.g. Chip to Chip).
+	Only say "M" here if you want to test XSHM and needs to load
+	and unload its module.
+	If unsure say N.
diff --git a/drivers/xshm/Makefile b/drivers/xshm/Makefile
new file mode 100644
index 0000000..954bd22
--- /dev/null
+++ b/drivers/xshm/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_XSHM) += xshm.o
+xshm-objs := xshm_boot.o xshm_dev.o
+obj-$(CONFIG_XSHM_CHR) +=  xshm_chr.o
-- 
1.7.0.4

