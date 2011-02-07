Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1BGBvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 20:51:05 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1100 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754203Ab1BGBui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 20:50:38 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23313
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 05/09] ARM: s3c2440: gta02: Fix regulator valid_modes_ops
Date: Mon,  7 Feb 2011 02:51:57 +0100
Message-Id: <1297043521-21903-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297043521-21903-1-git-send-email-lars@metafoo.de>
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The REGULATOR_CHANGE_STATUS flag needs to be set on valid_ops_mask, otherwise it
a driver wont be able to turn the regulator on or off.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/arm/mach-s3c2440/mach-gta02.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 6629998..e57c4d8 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -314,8 +314,8 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
 				.min_uV = 2000000,
 				.max_uV = 3300000,
 				.valid_modes_mask = REGULATOR_MODE_NORMAL,
-				.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
-				.always_on = 1,
+				.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+						REGULATOR_CHANGE_STATUS,
 			},
 		},
 		[PCF50633_REGULATOR_LDO1] = {
@@ -323,6 +323,7 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
 				.min_uV = 3300000,
 				.max_uV = 3300000,
 				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 				.apply_uV = 1,
 				.state_mem = {
 					.enabled = 0,
@@ -350,6 +351,7 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
 				.min_uV = 3200000,
 				.max_uV = 3200000,
 				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 				.apply_uV = 1,
 			},
 		},
@@ -358,6 +360,7 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
 				.min_uV = 3000000,
 				.max_uV = 3000000,
 				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 				.apply_uV = 1,
 				.state_mem = {
 					.enabled = 1,
-- 
1.7.2.3

