Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2BAFbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:31:53 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:59686
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751162Ab2BAFbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:31:52 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dhc1bhc31hc1ah87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] irq_domain: fix the irq number of imx5 tzic
Date: Wed, 1 Feb 2012 13:46:54 +0800
Message-ID: <1328075214-25700-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1327700179-17454-15-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-15-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tzic controller found on imx51 and imx53 gets 128 irq lines rather
than 32.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/mach-mx5/imx51-dt.c |    2 +-
 arch/arm/mach-mx5/imx53-dt.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mx5/imx51-dt.c b/arch/arm/mach-mx5/imx51-dt.c
index e1b5edf..1e03ef4 100644
--- a/arch/arm/mach-mx5/imx51-dt.c
+++ b/arch/arm/mach-mx5/imx51-dt.c
@@ -47,7 +47,7 @@ static const struct of_dev_auxdata imx51_auxdata_lookup[] __initconst = {
 static int __init imx51_tzic_add_irq_domain(struct device_node *np,
 				struct device_node *interrupt_parent)
 {
-	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
+	irq_domain_add_legacy(np, 128, 0, 0, &irq_domain_simple_ops, NULL);
 	return 0;
 }
 
diff --git a/arch/arm/mach-mx5/imx53-dt.c b/arch/arm/mach-mx5/imx53-dt.c
index 89de5d4..fd5be0f 100644
--- a/arch/arm/mach-mx5/imx53-dt.c
+++ b/arch/arm/mach-mx5/imx53-dt.c
@@ -51,7 +51,7 @@ static const struct of_dev_auxdata imx53_auxdata_lookup[] __initconst = {
 static int __init imx53_tzic_add_irq_domain(struct device_node *np,
 				struct device_node *interrupt_parent)
 {
-	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
+	irq_domain_add_legacy(np, 128, 0, 0, &irq_domain_simple_ops, NULL);
 	return 0;
 }
 
-- 
1.7.4.1


