Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1JBOr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:47:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1JBOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Avinash.H.M" <avinashhm@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 08/30] ARM: omap2+: fix building without i2c
Date: Sun,  2 Oct 2011 16:45:38 +0200
Message-Id: <1317566760-25681-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:RLg7l9wgZJ3g+NNBXKfoArKv+m8LHpkk10bAj9fZQaI
 zLWMOtbtYnNZhQyc2dBTpvPrOwDZp6qiVO/VX7rgSjAqwkvucf
 FFVnH3AzYzXzNAPqL51Xq3gck8FlptEY7C4GUe1f3qgkehZTrH
 9xLdDl1kZrqAPhu1UWO+/yzLqZPRYbVVl+jC2Wg/u4wEptvRLB
 2MvcQ5UNiL1q9lvbo6zA7O4AJ+AHsWw98O1t4t9VzRxFvUzoNx
 wr76KxxVZ5NdG27Mnwv6bGBGYnjjKakFWSVhDk9DjrHL+JwGQF
 itax/zP9drWPOTOqX1VUlaijHHZaeuf2KqxQTKucGRWo38w/dE
 KXeE5ModTRzutk+6Q+gzOakBhuRqp1QI1XsMhdUdzQOrEE2CT6
 htnA76YZ8dIxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A trivial typo causes build breakage when I2C is disabled
and omap_i2c_reset is set to NULL on OMAP:

omap_hwmod_44xx_data.c:2287:11: error: lvalue required as unary '&' operand

Removing the '&' character solves this.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Avinash.H.M <avinashhm@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_2420_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_2420_data.c b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
index a015c69..3aa6c62 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2420_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
@@ -1030,7 +1030,7 @@ static struct omap_hwmod_class i2c_class = {
 	.name		= "i2c",
 	.sysc		= &i2c_sysc,
 	.rev		= OMAP_I2C_IP_VERSION_1,
-	.reset		= &omap_i2c_reset,
+	.reset		= omap_i2c_reset,
 };
 
 static struct omap_i2c_dev_attr i2c_dev_attr = {
diff --git a/arch/arm/mach-omap2/omap_hwmod_2430_data.c b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
index 16743c7..d9ab245 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2430_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
@@ -1079,7 +1079,7 @@ static struct omap_hwmod_class i2c_class = {
 	.name		= "i2c",
 	.sysc		= &i2c_sysc,
 	.rev		= OMAP_I2C_IP_VERSION_1,
-	.reset		= &omap_i2c_reset,
+	.reset		= omap_i2c_reset,
 };
 
 static struct omap_i2c_dev_attr i2c_dev_attr = {
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 25bf43b..b0a0113 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -1309,7 +1309,7 @@ static struct omap_hwmod_class i2c_class = {
 	.name	= "i2c",
 	.sysc	= &i2c_sysc,
 	.rev	= OMAP_I2C_IP_VERSION_1,
-	.reset	= &omap_i2c_reset,
+	.reset	= omap_i2c_reset,
 };
 
 static struct omap_hwmod_dma_info omap3xxx_dss_sdma_chs[] = {
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 6201422..a6d42fc 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -2284,7 +2284,7 @@ static struct omap_hwmod_class omap44xx_i2c_hwmod_class = {
 	.name	= "i2c",
 	.sysc	= &omap44xx_i2c_sysc,
 	.rev	= OMAP_I2C_IP_VERSION_2,
-	.reset	= &omap_i2c_reset,
+	.reset	= omap_i2c_reset,
 };
 
 static struct omap_i2c_dev_attr i2c_dev_attr = {
-- 
1.7.5.4

