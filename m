Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab1LBR3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:29:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33353 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1LBR27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:28:59 -0500
Date: Fri, 2 Dec 2011 17:28:54 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com
Subject: Re: [PATCH] net/macb: add DT support
Message-ID: <20111202172854.GB4998@totoro>
References: <20111202153832.GA4998@totoro>
 <1322846050-4543-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322846050-4543-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Fri, Dec 02, 2011 at 06:14:10PM +0100, Nicolas Ferre wrote:
> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Allow the device tree to provide the mac address and the phy mode.
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> [nicolas.ferre@atmel.com: change "compatible" node property, doc and DT hwaddr]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jamie Iles <jamie@jamieiles.com>

Looks nice to me.  There's a patch below to add the GEM stuff to the 
binding too if you want to role that in.

Acked-by: Jamie Iles <jamie@jamieiles.com>

8<----

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 7f0b90a..e09e3fb 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -1,9 +1,11 @@
-* Cadence MACB Ethernet controller
+* Cadence MACB/GEM Ethernet controller
 
 Required properties:
-- compatible: Should be "cdns,[<chip>-]macb"
+- compatible: Should be "cdns,[<chip>-]{macb,gem}"
   Use "cdns,at91sam9260-macb" Atmel at91sam9260 and at91sam9263 SoCs.
   Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb"
+  Use "cnds,pc302-gem" for Picochip picoXcell pc302 and later devices based on
+  the Cadence GEM, or the generic form "cdns,gem".
 - reg: Address and length of the register set for the device
 - interrupts: Should contain macb interrupt
 - phy-mode: String, operation mode of the PHY interface.
diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 103c6e6..89060e6 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1247,6 +1247,8 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,at32ap7000-macb" },
 	{ .compatible = "cdns,at91sam9260-macb" },
 	{ .compatible = "cdns,macb" },
+	{ .compatible = "cdns,pc302-gem" },
+	{ .compatible = "cdns,gem" },
 	{ /* sentinel */ }
 };
 
