Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750841Ab0FCEGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:06:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37776 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0FCEGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:06:05 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: devicetree-discuss@ozlabs.org
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/2] of/powerpc: fix fsl_msi device node pointer
Date: Thu,  3 Jun 2010 06:03:46 +0200
Message-Id: <1275537827-28921-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/sysdev/fsl_msi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 0f5bee9..962c2d8 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -347,7 +347,7 @@ static int __devinit fsl_of_msi_probe(struct of_device *dev,
 		goto error_out;
 	}
 	offset = 0;
-	p = of_get_property(dev->node, "msi-available-ranges", &len);
+	p = of_get_property(dev->dev.of_node, "msi-available-ranges", &len);
 	if (p)
 		offset = *p / IRQS_PER_MSI_REG;
 
-- 
1.7.0

