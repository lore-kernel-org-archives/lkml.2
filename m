Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1LGJ3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:29:00 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38396 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950Ab1LGJ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:28:34 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Paul Bolle <pebolle@tiscali.nl>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory Drivers
Date: Wed,  7 Dec 2011 10:28:07 +0100
Message-Id: <1323250088-1729-9-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
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
index 0000000..80daca4
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
+	Say "Y" to use a character device for the External Shared
+	Memory (XSHM) IPC mechanism. XSHM is an IPC protocol used to
+	talk to external device such as modem over a shared memory
+	(e.g. Chip to Chip).
+	Only say "M" here if you want to test XSHM and need to load
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

