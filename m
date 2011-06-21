Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab1FUSpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:45:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42562 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab1FUSpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:45:16 -0400
Subject: [PATCH 5/5] powerpc/5200: convert mpc5200 to use
 of_platform_populate()
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Date: Tue, 21 Jun 2011 12:45:13 -0600
Message-ID: <20110621184513.18176.24174.stgit@ponder>
In-Reply-To: <20110621181127.18176.1384.stgit@ponder>
References: <20110621181127.18176.1384.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_platform_populate() also handles nodes at the root of the tree,
which is wanted for things like describing the sound complex.  This
patch converts mpc5200 support to use of_platform_populate() instead
of of_platform_bus_probe().

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/platforms/52xx/mpc52xx_common.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_common.c b/arch/powerpc/platforms/52xx/mpc52xx_common.c
index 41f3a7e..6a2fde2 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_common.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_common.c
@@ -97,13 +97,11 @@ struct mpc52xx_gpio_wkup __iomem *wkup_gpio;
  *					of the localplus bus to the of_platform
  *					bus.
  */
-void __init
-mpc52xx_declare_of_platform_devices(void)
+void __init mpc52xx_declare_of_platform_devices(void)
 {
-	/* Find every child of the SOC node and add it to of_platform */
-	if (of_platform_bus_probe(NULL, mpc52xx_bus_ids, NULL))
-		printk(KERN_ERR __FILE__ ": "
-			"Error while probing of_platform bus\n");
+	/* Find all the 'platform' devices and register them. */
+	if (of_platform_populate(NULL, mpc52xx_bus_ids, NULL, NULL))
+		pr_err(__FILE__ ": Error while populating devices from DT\n");
 }
 
 /*

