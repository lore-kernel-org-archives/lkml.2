Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2GXGvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:51:40 -0400
Received: from nbd.name ([46.4.11.11]:43431 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab2GXGva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:51:30 -0400
From: John Crispin <blogic@openwrt.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: John Crispin <blogic@openwrt.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] Document: devicetree: add OF documents for lantiq xway pinctrl
Date: Tue, 24 Jul 2012 08:50:56 +0200
Message-Id: <1343112660-12245-2-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1343112660-12245-1-git-send-email-blogic@openwrt.org>
References: <1343112660-12245-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Crispin <blogic@openwrt.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 .../bindings/pinctrl/lantiq,xway-pinumx.txt        |   97 ++++++++++++++++++++
 1 files changed, 97 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt b/Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt
new file mode 100644
index 0000000..b5469db
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/lantiq,xway-pinumx.txt
@@ -0,0 +1,97 @@
+Lantiq XWAY pinmux controller
+
+Required properties:
+- compatible: "lantiq,pinctrl-xway" or "lantiq,pinctrl-xr9"
+- reg: Should contain the physical address and length of the gpio/pinmux
+  register range
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+Lantiq's pin configuration nodes act as a container for an abitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin, a group, or a list of pins or groups. This configuration can include the
+mux function to select on those group(s), and two pin configuration parameters:
+pull-up and open-drain
+
+The name of each subnode is not important as long as it is unique; all subnodes
+should be enumerated and processed purely based on their content.
+
+Each subnode only affects those parameters that are explicitly listed. In
+other words, a subnode that lists a mux function but no pin configuration
+parameters implies no information about any pin configuration parameters.
+Similarly, a pin subnode that describes a pullup parameter implies no
+information about e.g. the mux function.
+
+We support 2 types of nodes.
+
+Definition of mux function groups:
+
+Required subnode-properties:
+- lantiq,groups : An array of strings. Each string contains the name of a group.
+  Valid values for these names are listed below.
+- lantiq,function: A string containing the name of the function to mux to the
+  group. Valid values for function names are listed below.
+
+Valid values for group and function names:
+
+  mux groups:
+    exin0, exin1, exin2, jtag, ebu a23, ebu a24, ebu a25, ebu clk, ebu cs1,
+    ebu wait, nand ale, nand cs1, nand cle, spi, spi_cs1, spi_cs2, spi_cs3,
+    spi_cs4, spi_cs5, spi_cs6, asc0, asc0 cts rts, stp, nmi , gpt1, gpt2,
+    gpt3, clkout0, clkout1, clkout2, clkout3, gnt1, gnt2, gnt3, req1, req2,
+    req3
+
+  additional mux groups (XR9 only):
+    mdio, nand rdy, nand rd, exin3, exin4, gnt4, req4
+
+  functions:
+    spi, asc, cgu, jtag, exin, stp, gpt, nmi, pci, ebu, mdio
+
+
+
+Definition of pin configurations:
+
+Required subnode-properties:
+- lantiq,pins : An array of strings. Each string contains the name of a pin.
+  Valid values for these names are listed below.
+
+Optional subnode-properties:
+- lantiq,pull: Integer, representing the pull-down/up to apply to the pin.
+    0: none, 1: down, 2: up.
+- lantiq,open-drain: Boolean, enables open-drain on the defined pin.
+
+Valid values for XWAY pin names:
+  Pinconf pins can be referenced via the names io0-io31.
+
+Valid values for XR9 pin names:
+  Pinconf pins can be referenced via the names io0-io55.
+
+Example:
+	gpio: pinmux@E100B10 {
+		compatible = "lantiq,pinctrl-xway";
+		pinctrl-names = "default";
+		pinctrl-0 = <&state_default>;
+
+		#gpio-cells = <2>;
+		gpio-controller;
+		reg = <0xE100B10 0xA0>;
+
+		state_default: pinmux {
+			stp {
+				lantiq,groups = "stp";
+				lantiq,function = "stp";
+			};
+			pci {
+				lantiq,groups = "gnt1";
+				lantiq,function = "pci";
+			};
+			conf_out {
+				lantiq,pins = "io4", "io5", "io6"; /* stp */
+				lantiq,open-drain;
+				lantiq,pull = <0>;
+			};
+		};
+	};
+
-- 
1.7.9.1

