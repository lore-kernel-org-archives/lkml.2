Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2KKMup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:50:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2KKMuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:39 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] MIPS: BCM63XX: add generic fallback device trees
Date: Sun, 11 Nov 2012 13:50:37 +0100
Message-Id: <1352638249-29298-4-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic fallback device trees to load if there is no specific
device tree for the board available. This ensures that always present
devices like interrupt controllers are always available.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 arch/mips/bcm63xx/dts/Makefile             |    8 ++++++++
 arch/mips/bcm63xx/dts/bcm96328_generic.dts |   21 +++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm96338_generic.dts |   21 +++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm96345_generic.dts |   21 +++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm96348_generic.dts |   21 +++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm96358_generic.dts |   21 +++++++++++++++++++++
 arch/mips/bcm63xx/dts/bcm96368_generic.dts |   21 +++++++++++++++++++++
 arch/mips/bcm63xx/setup.c                  |   17 +++++++++++------
 8 files changed, 145 insertions(+), 6 deletions(-)
 create mode 100644 arch/mips/bcm63xx/dts/bcm96328_generic.dts
 create mode 100644 arch/mips/bcm63xx/dts/bcm96338_generic.dts
 create mode 100644 arch/mips/bcm63xx/dts/bcm96345_generic.dts
 create mode 100644 arch/mips/bcm63xx/dts/bcm96348_generic.dts
 create mode 100644 arch/mips/bcm63xx/dts/bcm96358_generic.dts
 create mode 100644 arch/mips/bcm63xx/dts/bcm96368_generic.dts

diff --git a/arch/mips/bcm63xx/dts/Makefile b/arch/mips/bcm63xx/dts/Makefile
index 69c374b..94d1057 100644
--- a/arch/mips/bcm63xx/dts/Makefile
+++ b/arch/mips/bcm63xx/dts/Makefile
@@ -1,2 +1,10 @@
+# generic fallback boards
+obj-$(CONFIG_BCM63XX_CPU_6328)		+= bcm96328_generic.dtb.o
+obj-$(CONFIG_BCM63XX_CPU_6338)		+= bcm96338_generic.dtb.o
+obj-$(CONFIG_BCM63XX_CPU_6345)		+= bcm96345_generic.dtb.o
+obj-$(CONFIG_BCM63XX_CPU_6348)		+= bcm96348_generic.dtb.o
+obj-$(CONFIG_BCM63XX_CPU_6358)		+= bcm96358_generic.dtb.o
+obj-$(CONFIG_BCM63XX_CPU_6368)		+= bcm96368_generic.dtb.o
+
 $(obj)/%.dtb: $(obj)/%.dts
 	$(call if_changed,dtc)
diff --git a/arch/mips/bcm63xx/dts/bcm96328_generic.dts b/arch/mips/bcm63xx/dts/bcm96328_generic.dts
new file mode 100644
index 0000000..13cdc48
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm96328_generic.dts
@@ -0,0 +1,21 @@
+/dts-v1/;
+
+/*
+ * Fallback Device Tree Source for Broadcom BCM6328 based boards
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6328.dtsi"
+
+/ {
+	model = "Generic BCM6328 board";
+	compatible = "bcm96328-generic";
+
+	ubus@10000000 {
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm96338_generic.dts b/arch/mips/bcm63xx/dts/bcm96338_generic.dts
new file mode 100644
index 0000000..3b4e7b0
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm96338_generic.dts
@@ -0,0 +1,21 @@
+/dts-v1/;
+
+/*
+ * Fallback Device Tree Source for Broadcom BCM6338 based boards
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6338.dtsi"
+
+/ {
+	model = "Generic BCM6338 board";
+	compatible = "bcm96338-generic";
+
+	ubus@fffe0000 {
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm96345_generic.dts b/arch/mips/bcm63xx/dts/bcm96345_generic.dts
new file mode 100644
index 0000000..2bbf69e
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm96345_generic.dts
@@ -0,0 +1,21 @@
+/dts-v1/;
+
+/*
+ * Fallback Device Tree Source for Broadcom BCM6345 based boards
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6345.dtsi"
+
+/ {
+	model = "Generic BCM6345 board";
+	compatible = "bcm96345-generic";
+
+	ubus@fffe0000 {
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm96348_generic.dts b/arch/mips/bcm63xx/dts/bcm96348_generic.dts
new file mode 100644
index 0000000..d3c21a9
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm96348_generic.dts
@@ -0,0 +1,21 @@
+/dts-v1/;
+
+/*
+ * Fallback Device Tree Source for Broadcom BCM6348 based boards
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6348.dtsi"
+
+/ {
+	model = "Generic BCM6348 board";
+	compatible = "bcm96348-generic";
+
+	ubus@fffe0000 {
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm96358_generic.dts b/arch/mips/bcm63xx/dts/bcm96358_generic.dts
new file mode 100644
index 0000000..7db5b8f
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm96358_generic.dts
@@ -0,0 +1,21 @@
+/dts-v1/;
+
+/*
+ * Fallback Device Tree Source for Broadcom BCM6358 based boards
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6358.dtsi"
+
+/ {
+	model = "Generic BCM6358 board";
+	compatible = "bcm96358-generic";
+
+	ubus@fffe0000 {
+	};
+};
diff --git a/arch/mips/bcm63xx/dts/bcm96368_generic.dts b/arch/mips/bcm63xx/dts/bcm96368_generic.dts
new file mode 100644
index 0000000..a5c79a6
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/bcm96368_generic.dts
@@ -0,0 +1,21 @@
+/dts-v1/;
+
+/*
+ * Fallback Device Tree Source for Broadcom BCM6368 based boards
+ *
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "bcm6368.dtsi"
+
+/ {
+	model = "Generic BCM6368 board";
+	compatible = "bcm96368-generic";
+
+	ubus@10000000 {
+	};
+};
diff --git a/arch/mips/bcm63xx/setup.c b/arch/mips/bcm63xx/setup.c
index 8712354..b1fa63d 100644
--- a/arch/mips/bcm63xx/setup.c
+++ b/arch/mips/bcm63xx/setup.c
@@ -209,9 +209,16 @@ void __init device_tree_init(void)
 
 	devtree = find_compatible_tree(of_ids[0].compatible);
 	if (!devtree) {
-		pr_warn("no compatible device tree found for board %s\n"
+		pr_warn("no compatible device tree found for board %s, using fallback tree\n",
 			of_ids[0].compatible);
-		return;
+
+		snprintf(of_ids[0].compatible, sizeof(of_ids[0].compatible),
+			 "bcm9%x-generic", bcm63xx_get_cpu_id());
+		devtree = find_compatible_tree(of_ids[0].compatible);
+
+		if (!devtree)
+			panic("no fallback tree available for BCM%x!\n",
+			      bcm63xx_get_cpu_id());
 	}
 
 	__dt_setup_arch(devtree);
@@ -223,10 +230,8 @@ void __init device_tree_init(void)
 
 int __init bcm63xx_populate_device_tree(void)
 {
-	if (!of_have_populated_dt()) {
-		pr_warn("device tree not available\n");
-		return -ENODEV;
-	}
+	if (!of_have_populated_dt())
+		panic("device tree not available\n");
 
 	return of_platform_populate(NULL, of_ids, NULL, NULL);
 }
-- 
1.7.2.5

