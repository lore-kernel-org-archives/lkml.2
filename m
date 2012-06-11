Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab2FKLCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:02:42 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:42885 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753662Ab2FKLCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:02:41 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 5/14] ARM: LPC32xx: Adjust dtsi file for MLC controller configuration
Date: Mon, 11 Jun 2012 13:02:08 +0200
Message-Id: <1339412537-24485-6-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339412537-24485-1-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch takes into account that the MTD NAND MLC controller needs more
registers, located actually before the previously allocated memory range,
already starting at 200a8000 instead of 200b0000.

Further, the interrupt for the controller is configured.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/boot/dts/lpc32xx.dtsi |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -38,9 +38,10 @@
 			status = "disable";
 		};
 
-		mlc: flash@200B0000 {
+		mlc: flash@200a8000 {
 			compatible = "nxp,lpc3220-mlc";
-			reg = <0x200B0000 0x1000>;
+			reg = <0x200a8000 0x11000>;
+			interrupts = <11 0>;
 			status = "disable";
 		};
 
