Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2FNQvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:44 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:33205 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932129Ab2FNQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:33 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 01/23] ARM: LPC32xx: Add NAND flash timing to PHY3250 board dts
Date: Thu, 14 Jun 2012 18:50:51 +0200
Message-Id: <1339692673-7848-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds necessary NAND flash timings to the board specific dts file of
the PHY3250 reference board of the LPC32xx SoC.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

---
 arch/arm/boot/dts/phy3250.dts |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- linux-2.6.orig/arch/arm/boot/dts/phy3250.dts
+++ linux-2.6/arch/arm/boot/dts/phy3250.dts
@@ -54,6 +54,17 @@
 			#address-cells = <1>;
 			#size-cells = <1>;
 
+			nxp,wdr-clks = <14>;
+			nxp,wwidth = <40000000>;
+			nxp,whold = <100000000>;
+			nxp,wsetup = <100000000>;
+			nxp,rdr-clks = <14>;
+			nxp,rwidth = <40000000>;
+			nxp,rhold = <66666666>;
+			nxp,rsetup = <100000000>;
+			nand-on-flash-bbt;
+			gpios = <&gpio 5 19 1>; /* GPO_P3 19, active low */
+
 			mtd0@00000000 {
 				label = "phy3250-boot";
 				reg = <0x00000000 0x00064000>;
