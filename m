Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2IQAuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33340 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976Ab2IQAt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:27 -0400
Message-Id: <20120917003628.454370011@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shawn Guo <shawn.guo@linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: [ 016/135] ARM: dts: imx51-babbage: fix esdhc cd/wp properties
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit a46d2619d7180bda12bad2bf15bbd0731dfc2dcf upstream.

The binding doc and dts use properties "fsl,{cd,wp}-internal" while
esdhc driver uses "fsl,{cd,wp}-controller".  Fix binding doc and dts
to get them match driver code.

Reported-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt |    8 ++++----
 arch/arm/boot/dts/imx51-babbage.dts                     |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
+++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
@@ -10,8 +10,8 @@ Required properties:
 
 Optional properties:
 - fsl,card-wired : Indicate the card is wired to host permanently
-- fsl,cd-internal : Indicate to use controller internal card detection
-- fsl,wp-internal : Indicate to use controller internal write protection
+- fsl,cd-controller : Indicate to use controller internal card detection
+- fsl,wp-controller : Indicate to use controller internal write protection
 - cd-gpios : Specify GPIOs for card detection
 - wp-gpios : Specify GPIOs for write protection
 
@@ -21,8 +21,8 @@ esdhc@70004000 {
 	compatible = "fsl,imx51-esdhc";
 	reg = <0x70004000 0x4000>;
 	interrupts = <1>;
-	fsl,cd-internal;
-	fsl,wp-internal;
+	fsl,cd-controller;
+	fsl,wp-controller;
 };
 
 esdhc@70008000 {
--- a/arch/arm/boot/dts/imx51-babbage.dts
+++ b/arch/arm/boot/dts/imx51-babbage.dts
@@ -29,8 +29,8 @@
 		aips@70000000 { /* aips-1 */
 			spba@70000000 {
 				esdhc@70004000 { /* ESDHC1 */
-					fsl,cd-internal;
-					fsl,wp-internal;
+					fsl,cd-controller;
+					fsl,wp-controller;
 					status = "okay";
 				};
 


