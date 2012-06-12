Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2FLOmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:42:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39737 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2FLOmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:42:12 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, mturquette@linaro.org,
        sboyd@codeaurora.org, skannan@codeaurora.org, shawn.guo@linaro.org,
        s.hauer@pengutronix.de, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v3 3/4] dt: add clock binding doc to primecell bindings
Date: Tue, 12 Jun 2012 09:41:50 -0500
Message-Id: <1339512111-11172-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add clock binding information for primecell peripherals. For most, a
clock input name of "apb_pclk" is required. Any primecell peripherals
which are different will need to be documented separately.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 .../devicetree/bindings/arm/primecell.txt          |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/primecell.txt b/Documentation/devicetree/bindings/arm/primecell.txt
index 951ca46..64fc82b 100644
--- a/Documentation/devicetree/bindings/arm/primecell.txt
+++ b/Documentation/devicetree/bindings/arm/primecell.txt
@@ -13,11 +13,17 @@ Required properties:
 Optional properties:
 
 - arm,primecell-periphid : Value to override the h/w value with
+- clocks : From common clock binding. First clock is phandle to clock for apb
+	pclk. Additional clocks are optional and specific to those peripherals.
+- clock-names : From common clock binding. Shall be "apb_pclk" for first clock.
 
 Example:
 
 serial@fff36000 {
 	compatible = "arm,pl011", "arm,primecell";
 	arm,primecell-periphid = <0x00341011>;
+	clocks = <&pclk>;
+	clock-names = "apb_pclk";
+	
 };
 
-- 
1.7.9.5

