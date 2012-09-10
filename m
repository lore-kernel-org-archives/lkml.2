Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2IJDkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:40:46 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:53012 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab2IJDkn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:40:43 -0400
From: Yunfan Zhang <yfzhang@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@gmail.com>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 9 Sep 2012 20:40:24 -0700
Subject: [PATCH] regulator: fan53555: remove vsel_max not used
Thread-Topic: [PATCH] regulator: fan53555: remove vsel_max not used
Thread-Index: Ac2PBgLOITTEHt3MQAWdGBtHZTtlWA==
Message-ID: <4737A960563B524DA805CA602BE04B3064CC590795@SC-VEXCH2.marvell.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AOrL A9ff CZHE EoBd FL91 LVuv M6jj R7wi dmq/ ijKr jW9G
 krlP mE+P nfzR u77q
 wIOU;4;YQB4AGUAbAAuAGwAaQBuAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBiAHIAbwBvAG4AaQBlAEAAbwBwAGUAbgBzAG8AdQByAGMAZQAuAHcAbwBsAGYAcwBvAG4AbQBpAGMAcgBvAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbAByAGcAQAB0AGkALgBjAG8AbQA=;Sosha1_v1;7;{C3DCBBC8-A9D4-4ADC-8192-6F905524BF77};eQBmAHoAaABhAG4AZwBAAG0AYQByAHYAZQBsAGwALgBjAG8AbQA=;Mon,
 10 Sep 2012 03:40:24
 GMT;WwBQAEEAVABDAEgAXQAgAHIAZQBnAHUAbABhAHQAbwByADoAIABmAGEAbgA1ADMANQA1ADUAOgAgAHIAZQBtAG8AdgBlACAAdgBzAGUAbABfAG0AYQB4ACAAbgBvAHQAIAB1AHMAZQBkAA==
x-cr-puzzleid: {C3DCBBC8-A9D4-4ADC-8192-6F905524BF77}
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max voltage will be bounded by min_uV, uV_step and n_voltages, so
remove it to avoid confusing.

Signed-off-by: Yunfan Zhang <yfzhang@marvell.com>
---
 drivers/regulator/fan53555.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 890f2b3..339f4d7 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -74,7 +74,6 @@ struct fan53555_device_info {
 	unsigned int sleep_reg;
 	/* Voltage range and step(linear) */
 	unsigned int vsel_min;
-	unsigned int vsel_max;
 	unsigned int vsel_step;
 	/* Voltage slew rate limiting */
 	unsigned int slew_rate;
@@ -180,12 +179,10 @@ static int fan53555_device_setup(struct fan53555_device_info *di,
 	case FAN53555_CHIP_ID_03:
 	case FAN53555_CHIP_ID_05:
 		di->vsel_min = 600000;
-		di->vsel_max = 1230000;
 		di->vsel_step = 10000;
 		break;
 	case FAN53555_CHIP_ID_04:
 		di->vsel_min = 603000;
-		di->vsel_max = 1411000;
 		di->vsel_step = 12826;
 		break;
 	default:
-- 
1.7.0.4

