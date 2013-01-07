Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3AGSve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:51:34 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:58346 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121Ab3AGSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:51:31 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 3/5] capemgr: am335x-bone capemgr bindings
Date: Mon,  7 Jan 2013 20:51:04 +0200
Message-Id: <1357584666-17374-4-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bindings which enable the DT overlay based cape manager for
the Texas Instruments Beaglebone platform.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/boot/dts/am335x-bone.dts | 68 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index 11b240c..5faeece 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -38,7 +38,7 @@
 		};
 	};
 
-	ocp {
+	ocp: ocp {
 		uart1: serial@44e09000 {
 			status = "okay";
 		};
@@ -51,6 +51,35 @@
 				reg = <0x24>;
 			};
 
+			baseboard_eeprom: baseboard_eeprom@50 {
+				compatible = "at,24c256";
+				reg = <0x50>;
+			};
+		};
+
+		i2c3: i2c@4819c000 {
+			status = "okay";
+			clock-frequency = <100000>;
+
+			cape_eeprom0: cape_eeprom0@54 {
+				compatible = "at,24c256";
+				reg = <0x54>;
+			};
+
+			cape_eeprom1: cape_eeprom1@55 {
+				compatible = "at,24c256";
+				reg = <0x55>;
+			};
+
+			cape_eeprom2: cape_eeprom2@56 {
+				compatible = "at,24c256";
+				reg = <0x56>;
+			};
+
+			cape_eeprom3: cape_eeprom3@57 {
+				compatible = "at,24c256";
+				reg = <0x57>;
+			};
 		};
 	};
 
@@ -83,6 +112,43 @@
 			default-state = "off";
 		};
 	};
+
+	bone_capemgr {
+		compatible = "ti,bone-capemgr";
+		status = "okay";
+
+		eeprom = <&baseboard_eeprom>;
+
+		baseboardmaps {
+			baseboard_beaglebone: board@0 {
+				board-name = "A335BONE";
+				compatible-name = "ti,beaglebone";
+			};
+		};
+
+		slots {
+			slot@0 {
+				eeprom = <&cape_eeprom0>;
+			};
+
+			slot@1 {
+				eeprom = <&cape_eeprom1>;
+			};
+
+			slot@2 {
+				eeprom = <&cape_eeprom2>;
+			};
+
+			slot@3 {
+				eeprom = <&cape_eeprom3>;
+			};
+		};
+
+		/* mapping between board names and dtb objects */
+		capemaps {
+
+		};
+	};
 };
 
 /include/ "tps65217.dtsi"
-- 
1.7.12

