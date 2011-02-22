Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1BVU6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:58:22 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13986 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1BVU6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:58:18 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH 02/10] MIPS: Octeon: Add device tree source files.
Date: Tue, 22 Feb 2011 12:57:46 -0800
Message-Id: <1298408274-20856-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 22 Feb 2011 20:58:17.0285 (UTC) FILETIME=[3A933750:01CBD2D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/cavium-octeon/.gitignore      |    2 +
 arch/mips/cavium-octeon/Makefile        |   13 ++
 arch/mips/cavium-octeon/octeon_3xxx.dts |  314 +++++++++++++++++++++++++++++++
 arch/mips/cavium-octeon/octeon_68xx.dts |   99 ++++++++++
 4 files changed, 428 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/cavium-octeon/.gitignore
 create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts
 create mode 100644 arch/mips/cavium-octeon/octeon_68xx.dts

diff --git a/arch/mips/cavium-octeon/.gitignore b/arch/mips/cavium-octeon/.gitignore
new file mode 100644
index 0000000..39c9686
--- /dev/null
+++ b/arch/mips/cavium-octeon/.gitignore
@@ -0,0 +1,2 @@
+*.dtb.S
+*.dtb
diff --git a/arch/mips/cavium-octeon/Makefile b/arch/mips/cavium-octeon/Makefile
index 19eb043..5e25dce 100644
--- a/arch/mips/cavium-octeon/Makefile
+++ b/arch/mips/cavium-octeon/Makefile
@@ -15,3 +15,16 @@ obj-y += octeon-memcpy.o
 obj-y += executive/
 
 obj-$(CONFIG_SMP)                     += smp.o
+
+DTS_FILES = octeon_3xxx.dts octeon_68xx.dts
+DTB_FILES = $(patsubst %.dts, %.dtb, $(DTS_FILES))
+
+obj-y += $(patsubst %.dts, %.dtb.o, $(DTS_FILES))
+
+$(obj)/%.dtb: $(src)/%.dts
+	$(call cmd,dtc)
+
+# Let's keep the .dtb files around in case we want to look at them.
+.SECONDARY:  $(addprefix $(obj)/, $(DTB_FILES))
+
+clean-files += $(DTB_FILES) $(patsubst %.dtb, %.dtb.S, $(DTB_FILES))
diff --git a/arch/mips/cavium-octeon/octeon_3xxx.dts b/arch/mips/cavium-octeon/octeon_3xxx.dts
new file mode 100644
index 0000000..ad0feaa
--- /dev/null
+++ b/arch/mips/cavium-octeon/octeon_3xxx.dts
@@ -0,0 +1,314 @@
+/dts-v1/;
+/* OCTEON 3XXX, 5XXX, 63XX device tree skeleton. */
+/ {
+  model = "OCTEON";
+  compatible = "octeon,octeon";
+  #address-cells = <2>;
+  #size-cells = <2>;
+
+  soc@0 {
+    device_type = "soc";
+    compatible = "simple-bus";
+    #address-cells = <2>;
+    #size-cells = <2>;
+    ranges; /* Direct mapping */
+
+    ciu: ciu-3xxx@1070000000000 {
+      compatible = "octeon,ciu-3xxx";
+      interrupt-controller;
+      #address-cells = <0>;
+      #interrupt-cells = <2>;
+      reg = <0x10700 0x00000000 0x0 0x7000>;
+    };
+
+    /* SMI0 */
+    mdio0: mdio@1180000001800 {
+      compatible = "octeon,mdio";
+      #address-cells = <1>;
+      #size-cells = <0>;
+      reg = <0x11800 0x00001800 0x0 0x40>;
+      device_type = "mdio";
+
+      phy0: ethernet-phy@0 {
+	reg = <0>;
+      };
+
+      phy1: ethernet-phy@1 {
+	reg = <1>;
+      };
+
+      phy2: ethernet-phy@2 {
+	reg = <2>;
+	marvell,reg-init = <3 0x10 0 0x5777>,
+			   <3 0x11 0 0x00aa>,
+                           <3 0x12 0 0x4105>,
+                           <3 0x13 0 0x0a60>;
+      };
+      phy3: ethernet-phy@3 {
+	reg = <3>;
+	marvell,reg-init = <3 0x10 0 0x5777>,
+			   <3 0x11 0 0x00aa>,
+                           <3 0x12 0 0x4105>,
+                           <3 0x13 0 0x0a60>;
+      };
+      phy4: ethernet-phy@4 {
+	reg = <4>;
+	marvell,reg-init = <3 0x10 0 0x5777>,
+			   <3 0x11 0 0x00aa>,
+                           <3 0x12 0 0x4105>,
+                           <3 0x13 0 0x0a60>;
+      };
+      phy5: ethernet-phy@5 {
+	reg = <5>;
+	marvell,reg-init = <3 0x10 0 0x5777>,
+			   <3 0x11 0 0x00aa>,
+                           <3 0x12 0 0x4105>,
+                           <3 0x13 0 0x0a60>;
+      };
+
+      phy6: ethernet-phy@6 {
+	reg = <6>;
+	marvell,reg-init = <3 0x10 0 0x5777>,
+			   <3 0x11 0 0x00aa>,
+                           <3 0x12 0 0x4105>,
+                           <3 0x13 0 0x0a60>;
+      };
+      phy7: ethernet-phy@7 {
+	reg = <7>;
+	marvell,reg-init = <3 0x10 0 0x5777>,
+			   <3 0x11 0 0x00aa>,
+                           <3 0x12 0 0x4105>,
+                           <3 0x13 0 0x0a60>;
+      };
+      phy8: ethernet-phy@8 {
+	reg = <8>;
+	marvell,reg-init = <3 0x10 0 0x5777>,
+			   <3 0x11 0 0x00aa>,
+                           <3 0x12 0 0x4105>,
+                           <3 0x13 0 0x0a60>;
+      };
+      phy9: ethernet-phy@9 {
+	reg = <9>;
+	marvell,reg-init = <3 0x10 0 0x5777>,
+			   <3 0x11 0 0x00aa>,
+                           <3 0x12 0 0x4105>,
+                           <3 0x13 0 0x0a60>;
+      };
+    };
+
+    /* SMI1 */
+    mdio1: mdio@1180000001900 {
+      compatible = "octeon,mdio";
+      #address-cells = <1>;
+      #size-cells = <0>;
+      reg = <0x11800 0x00001900 0x0 0x40>;
+      device_type = "mdio";
+    };
+
+    mgmt0: ethernet@1070000100000 {
+      compatible = "octeon,mgmt";
+      device_type = "network";
+      model = "mgmt";
+      reg = <0x10700 0x00100000 0x0 0x100>, /* MIX */
+            <0x11800 0xE0000000 0x0 0x300>, /* AGL */
+            <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
+            <0x11800 0xE0002000 0x0 0x8>;   /* AGL_PRT_CTL */
+      unit-number = <0>;
+      interrupt-parent = <&ciu>;
+      interrupts = <0 62>, <1 46>;
+      local-mac-address = [ 00 00 00 00 00 00 ];
+      phy-handle = <&phy0>;
+    };
+
+    mgmt1: ethernet@1070000100800 {
+      compatible = "octeon,mgmt";
+      device_type = "network";
+      model = "mgmt";
+      reg = <0x10700 0x00100800 0x0 0x100>, /* MIX */
+            <0x11800 0xE0000800 0x0 0x300>, /* AGL */
+            <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
+            <0x11800 0xE0002008 0x0 0x8>;   /* AGL_PRT_CTL */
+      unit-number = <1>;
+      interrupt-parent = <&ciu>;
+      interrupts = <1 18>, < 1 46>;
+      local-mac-address = [ 00 00 00 00 00 00 ];
+      phy-handle = <&phy1>;
+    };
+
+    pip: pip@11800a0000000 {
+      compatible = "octeon,pip";
+      #address-cells = <1>;
+      #size-cells = <0>;
+      reg = <0x11800 0xa0000000 0x0 0x2000>;
+
+      interface@0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <0>; /* interface */
+
+        ethernet@0 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x0>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+          phy-handle = <&phy2>;
+        };
+        ethernet@1 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x1>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+          phy-handle = <&phy3>;
+        };
+        ethernet@2 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x2>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+          phy-handle = <&phy4>;
+        };
+        ethernet@3 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x3>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+          phy-handle = <&phy5>;
+        };
+      };
+
+      interface@1 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <1>; /* interface */
+
+        ethernet@0 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x0>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+          phy-handle = <&phy6>;
+        };
+        ethernet@1 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x1>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+          phy-handle = <&phy7>;
+        };
+        ethernet@2 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x2>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+          phy-handle = <&phy8>;
+        };
+        ethernet@3 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x3>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+          phy-handle = <&phy9>;
+        };
+      };
+
+      interface@2 { /* DPI interface. */
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <2>; /* interface */
+
+        ethernet@0 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x0>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+        };
+        ethernet@1 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x1>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+        };
+        ethernet@2 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x2>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+        };
+        ethernet@3 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x3>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+        };
+      };
+
+      interface@3 { /* Loop interface. */
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <3>; /* interface */
+
+        ethernet@0 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x0>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+        };
+        ethernet@1 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x1>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+        };
+        ethernet@2 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x2>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+        };
+        ethernet@3 {
+          device_type = "network";
+          model = "pip";
+          reg = <0x3>; /* Port */
+          local-mac-address = [ 00 00 00 00 00 00 ];
+        };
+      };
+    };
+
+    /* TWSI 0 */
+    i2c0: i2c@1180000001000 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "octeon,twsi";
+      reg = <0x11800 0x00001000 0x0 0x200>;
+      interrupt-parent = <&ciu>;
+      interrupts = <0 45>;
+      clock-rate = <100000>;
+
+      rtc@68 {
+        compatible = "dallas,ds1337";
+        reg = <0x68>;
+      };
+    };
+
+    /* TWSI 1 */
+    i2c1: i2c@1180000001200 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "octeon,twsi";
+      reg = <0x11800 0x00001200 0x0 0x200>;
+      interrupt-parent = <&ciu>;
+      interrupts = <0 59>;
+      clock-rate = <100000>;
+    };
+  };
+
+  aliases {
+    ethernet-mgmt0 = &mgmt0;
+    ethernet-mgmt1 = &mgmt1;
+    pip = &pip;
+    mdio0 = &mdio0;
+    mdio1 = &mdio1;
+    i2c0 = &i2c0;
+    i2c1 = &i2c1;
+  };
+};
diff --git a/arch/mips/cavium-octeon/octeon_68xx.dts b/arch/mips/cavium-octeon/octeon_68xx.dts
new file mode 100644
index 0000000..31dbd39
--- /dev/null
+++ b/arch/mips/cavium-octeon/octeon_68xx.dts
@@ -0,0 +1,99 @@
+/dts-v1/;
+/* OCTEON 68XX device tree skeleton. */
+/ {
+  model = "OCTEON";
+  compatible = "octeon,octeon";
+  #address-cells = <2>;
+  #size-cells = <2>;
+
+  soc@0 {
+    device_type = "soc";
+    compatible = "simple-bus";
+    #address-cells = <2>;
+    #size-cells = <2>;
+    ranges; /* Direct mapping */
+
+    ciu: ciu-68xx@1070100000000 {
+      compatible = "octeon,ciu-68xx";
+      interrupt-controller;
+      #address-cells = <0>;
+      #interrupt-cells = <2>;
+      reg = <0x10701 0x00000000 0x0 0x4000000>;
+    };
+
+    /* SMI0 */
+    mdio0: mdio@1180000003800 {
+      compatible = "octeon,mdio";
+      #address-cells = <1>;
+      #size-cells = <0>;
+      reg = <0x11800 0x00003800 0x0 0x40>;
+      device_type = "mdio";
+
+      phy0: ethernet-phy@0 {
+	reg = <0>;
+	device_type = "ethernet-phy";
+      };
+
+      phy1: ethernet-phy@1 {
+	reg = <1>;
+	device_type = "ethernet-phy";
+      };
+
+      phy3: ethernet-phy@3 {
+	reg = <3>;
+	device_type = "ethernet-phy";
+      };
+    };
+
+    /* SMI1 */
+    mdio1: mdio@1180000003880 {
+      compatible = "octeon,mdio";
+      #address-cells = <1>;
+      #size-cells = <0>;
+      reg = <0x11800 0x00003880 0x0 0x40>;
+      device_type = "mdio";
+    };
+
+    /* SMI2 */
+    mdio2: mdio@1180000003900 {
+      compatible = "octeon,mdio";
+      #address-cells = <1>;
+      #size-cells = <0>;
+      reg = <0x11800 0x00003900 0x0 0x40>;
+      device_type = "mdio";
+    };
+
+    /* SMI3 */
+    mdio3: mdio@1180000003980 {
+      compatible = "octeon,mdio";
+      #address-cells = <1>;
+      #size-cells = <0>;
+      reg = <0x11800 0x00003980 0x0 0x40>;
+      device_type = "mdio";
+    };
+
+    mgmt0: ethernet@1070000100000 {
+      compatible = "octeon,mgmt";
+      device_type = "network";
+      model = "mgmt";
+      /* Register banks: MIX AGL AGL_SHARED AGL_PRT_CTL*/
+      reg = <0x10700 0x00100000 0x0 0x100>, /* MIX */
+            <0x11800 0xE0000000 0x0 0x300>, /* AGL */
+            <0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
+            <0x11800 0xE0002000 0x0 0x8>;   /* AGL_PRT_CTL */
+      unit-number = <0>;
+      interrupt-parent = <&ciu>;
+      interrupts = <6 40>, <6 32>;
+      local-mac-address = [ 00 00 00 00 00 00 ];
+      phy-handle = <&phy0>;
+    };
+
+  };
+  aliases {
+    ethernet-mgmt0 = &mgmt0;
+    mdio0 = &mdio0;
+    mdio1 = &mdio1;
+    mdio2 = &mdio2;
+    mdio3 = &mdio3;
+  };
+};
-- 
1.7.2.3

