Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1AZFTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 00:19:48 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:43037 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1AZFTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 00:19:47 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, Nicolas Pitre <nico@fluxnic.net>,
        netdev@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH v4] smc91x: add devicetree support
Date: Wed, 26 Jan 2011 13:22:05 +0800
Message-Id: <1296019325-17801-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <20110125.194532.71125517.davem@davemloft.net>
References: <20110125.194532.71125517.davem@davemloft.net>
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
v2 specify part numbers in compat as Grant suggested.
v3 more specific part name.
v4 include match table only for OF as David suggested.

 drivers/net/smc91x.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index 726df61..43654a3 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -81,6 +81,7 @@ static const char version[] =
 #include <linux/ethtool.h>
 #include <linux/mii.h>
 #include <linux/workqueue.h>
+#include <linux/of.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
@@ -2394,6 +2395,15 @@ static int smc_drv_resume(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id smc91x_match[] = {
+	{ .compatible = "smsc,lan91c94", },
+	{ .compatible = "smsc,lan91c111", },
+	{},
+}
+MODULE_DEVICE_TABLE(of, smc91x_match);
+#endif
+
 static struct dev_pm_ops smc_drv_pm_ops = {
 	.suspend	= smc_drv_suspend,
 	.resume		= smc_drv_resume,
@@ -2406,6 +2416,9 @@ static struct platform_driver smc_driver = {
 		.name	= CARDNAME,
 		.owner	= THIS_MODULE,
 		.pm	= &smc_drv_pm_ops,
+#ifdef CONFIG_OF
+		.of_match_table = smc91x_match,
+#endif
 	},
 };
 
-- 
1.7.3.5

