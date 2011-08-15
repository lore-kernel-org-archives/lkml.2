Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1HOCOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 22:14:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65001 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1HOCOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 22:14:44 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] mmc: sdhci-esdhc-imx: add missing inclusion of linux/module.h
Date: Mon, 15 Aug 2011 10:28:18 +0800
Message-Id: <1313375298-18546-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are following warning and error when compiling the driver.
The patch adds the missing inclusion of linux/module.h to fix them.

drivers/mmc/host/sdhci-esdhc-imx.c:87:1: warning: data definition has no type or storage class
drivers/mmc/host/sdhci-esdhc-imx.c:87:1: warning: type defaults to ‘int’ in declaration of ‘MODULE_DEVICE_TABLE’
drivers/mmc/host/sdhci-esdhc-imx.c:87:1: warning: parameter names (without types) in function declaration
drivers/mmc/host/sdhci-esdhc-imx.c:96:1: warning: data definition has no type or storage class
drivers/mmc/host/sdhci-esdhc-imx.c:96:1: warning: type defaults to ‘int’ in declaration of ‘MODULE_DEVICE_TABLE’
drivers/mmc/host/sdhci-esdhc-imx.c:96:1: warning: parameter names (without types) in function declaration
drivers/mmc/host/sdhci-esdhc-imx.c:563:12: error: ‘THIS_MODULE’ undeclared here (not in a function)
drivers/mmc/host/sdhci-esdhc-imx.c:587:20: error: expected declaration specifiers or ‘...’ before string constant
drivers/mmc/host/sdhci-esdhc-imx.c:587:1: warning: data definition has no type or storage class
drivers/mmc/host/sdhci-esdhc-imx.c:587:1: warning: type defaults to ‘int’ in declaration of ‘MODULE_DESCRIPTION’
drivers/mmc/host/sdhci-esdhc-imx.c:587:20: warning: function declaration isn’t a prototype
drivers/mmc/host/sdhci-esdhc-imx.c:588:15: error: expected declaration specifiers or ‘...’ before string constant
drivers/mmc/host/sdhci-esdhc-imx.c:588:1: warning: data definition has no type or storage class
drivers/mmc/host/sdhci-esdhc-imx.c:588:1: warning: type defaults to ‘int’ in declaration of ‘MODULE_AUTHOR’
drivers/mmc/host/sdhci-esdhc-imx.c:588:15: warning: function declaration isn’t a prototype
drivers/mmc/host/sdhci-esdhc-imx.c:589:16: error: expected declaration specifiers or ‘...’ before string constant
drivers/mmc/host/sdhci-esdhc-imx.c:589:1: warning: data definition has no type or storage class
drivers/mmc/host/sdhci-esdhc-imx.c:589:1: warning: type defaults to ‘int’ in declaration of ‘MODULE_LICENSE’
drivers/mmc/host/sdhci-esdhc-imx.c:589:16: warning: function declaration isn’t a prototype

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Chris Ball <cjb@laptop.org>
---
Hi Stephen,

I spot this on linux-next-20110812.

Regards,
Shawn

 drivers/mmc/host/sdhci-esdhc-imx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 2a1ba84..4557aa1 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/gpio.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
-- 
1.7.4.1

