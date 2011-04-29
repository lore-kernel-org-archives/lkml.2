Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab1D2HQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 03:16:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47492 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab1D2HQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 03:16:00 -0400
Subject: [PATCH v5 6/8] arm/dt: Basic versatile devicetree support
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Fri, 29 Apr 2011 01:15:58 -0600
Message-ID: <20110429071558.12522.3709.stgit@ponder>
In-Reply-To: <20110429070135.12522.35745.stgit@ponder>
References: <20110429070135.12522.35745.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds adds very basic support for booting versatile with a
device tree.  It simply allows the existing machine_descs to match
against the versatile ab & pb compatible values so that the kernel can
boot.  Kernel parameters and the initrd pointer is read out of the
tree instead of atags.

This is not complete device tree support.  This change will be
reverted when a new machine_desc is added that can populate the
versatile device registrations directly from data in the tree instead
of using hard coded data.  That change will be made in a future patch.

v5: - Add skeleton device tree for versatile AB and PB.  Bare minimum needed
      for booting.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/skeleton.dtsi        |   13 +++++++++++++
 arch/arm/boot/dts/versatile-ab.dts     |    7 +++++++
 arch/arm/boot/dts/versatile-pb.dts     |    7 +++++++
 arch/arm/mach-versatile/versatile_ab.c |    6 ++++++
 arch/arm/mach-versatile/versatile_pb.c |    6 ++++++
 5 files changed, 39 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/skeleton.dtsi
 create mode 100644 arch/arm/boot/dts/versatile-ab.dts
 create mode 100644 arch/arm/boot/dts/versatile-pb.dts

diff --git a/arch/arm/boot/dts/skeleton.dtsi b/arch/arm/boot/dts/skeleton.dtsi
new file mode 100644
index 0000000..b41d241
--- /dev/null
+++ b/arch/arm/boot/dts/skeleton.dtsi
@@ -0,0 +1,13 @@
+/*
+ * Skeleton device tree; the bare minimum needed to boot; just include and
+ * add a compatible value.  The bootloader will typically populate the memory
+ * node.
+ */
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	chosen { };
+	aliases { };
+	memory { device_type = "memory"; reg = <0 0>; };
+};
diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
new file mode 100644
index 0000000..705a88f
--- /dev/null
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -0,0 +1,7 @@
+/dts-v1/;
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "ARM Versatile AB";
+	compatible = "arm,versatile-ab";
+};
diff --git a/arch/arm/boot/dts/versatile-pb.dts b/arch/arm/boot/dts/versatile-pb.dts
new file mode 100644
index 0000000..d8aabef
--- /dev/null
+++ b/arch/arm/boot/dts/versatile-pb.dts
@@ -0,0 +1,7 @@
+/dts-v1/;
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "ARM Versatile PB";
+	compatible = "arm,versatile-pb";
+};
diff --git a/arch/arm/mach-versatile/versatile_ab.c b/arch/arm/mach-versatile/versatile_ab.c
index f8ae64b..b7b49ad 100644
--- a/arch/arm/mach-versatile/versatile_ab.c
+++ b/arch/arm/mach-versatile/versatile_ab.c
@@ -33,6 +33,11 @@
 
 #include "core.h"
 
+static const char *versatile_ab_match[] __initdata = {
+	"arm,versatile-ab",
+	NULL,
+};
+
 MACHINE_START(VERSATILE_AB, "ARM-Versatile AB")
 	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
 	.boot_params	= 0x00000100,
@@ -41,4 +46,5 @@ MACHINE_START(VERSATILE_AB, "ARM-Versatile AB")
 	.init_irq	= versatile_init_irq,
 	.timer		= &versatile_timer,
 	.init_machine	= versatile_init,
+	.dt_compat	= versatile_ab_match,
 MACHINE_END
diff --git a/arch/arm/mach-versatile/versatile_pb.c b/arch/arm/mach-versatile/versatile_pb.c
index 37c23df..9d0bc5a 100644
--- a/arch/arm/mach-versatile/versatile_pb.c
+++ b/arch/arm/mach-versatile/versatile_pb.c
@@ -101,6 +101,11 @@ static void __init versatile_pb_init(void)
 	}
 }
 
+static const char *versatile_pb_match[] __initdata = {
+	"arm,versatile-pb",
+	NULL,
+};
+
 MACHINE_START(VERSATILE_PB, "ARM-Versatile PB")
 	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
 	.boot_params	= 0x00000100,
@@ -109,4 +114,5 @@ MACHINE_START(VERSATILE_PB, "ARM-Versatile PB")
 	.init_irq	= versatile_init_irq,
 	.timer		= &versatile_timer,
 	.init_machine	= versatile_pb_init,
+	.dt_compat	= versatile_pb_match,
 MACHINE_END

