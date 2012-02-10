Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002Ab2BJKFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:05:48 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:55379 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758931Ab2BJKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:05:45 -0500
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/7] OMAP: 4430SDP: Correct fixed regulator device ID
Date: Fri, 10 Feb 2012 12:05:10 +0200
Message-Id: <1328868316-24749-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
References: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The board has two fixed voltage regulator. Correct the
device ID for the vbat, which used -1.
Create defines for the fixed regulator IDs so when adding new
regulators we know the next available ID to use for them.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index f4ac553..d02172d 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -62,6 +62,9 @@
 #define GPIO_WIFI_PMENA		54
 #define GPIO_WIFI_IRQ		53
 
+#define FIXED_REG_VBAT_ID	0
+#define FIXED_REG_VWLAN_ID	1
+
 static const int sdp4430_keymap[] = {
 	KEY(0, 0, KEY_E),
 	KEY(0, 1, KEY_R),
@@ -368,7 +371,7 @@ static struct fixed_voltage_config sdp4430_vbat_pdata = {
 
 static struct platform_device sdp4430_vbat = {
 	.name		= "reg-fixed-voltage",
-	.id		= -1,
+	.id		= FIXED_REG_VBAT_ID,
 	.dev = {
 		.platform_data = &sdp4430_vbat_pdata,
 	},
@@ -478,7 +481,7 @@ static struct fixed_voltage_config sdp4430_vwlan = {
 
 static struct platform_device omap_vwlan_device = {
 	.name		= "reg-fixed-voltage",
-	.id		= 1,
+	.id		= FIXED_REG_VWLAN_ID,
 	.dev = {
 		.platform_data = &sdp4430_vwlan,
 	},
-- 
1.7.8.4

