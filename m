Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1I0Sum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:50:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57319 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab1I0SuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:50:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regulator: Add WM1811 support
Date: Tue, 27 Sep 2011 19:50:06 +0100
Message-Id: <1317149407-27635-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317149407-27635-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1317149407-27635-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM1811 has a slightly different range on LDO2 to other WM8994 class
devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

As with the ASoC patch this depends on the MFD changes - Liam, given
that ASoC is the thing most likely to run into cross-tree issues are you
OK with merging this via ASoC?

 drivers/regulator/wm8994-regulator.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 1a6a690..b87bf5c 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -140,6 +140,14 @@ static int wm8994_ldo2_list_voltage(struct regulator_dev *rdev,
 		return (selector * 100000) + 900000;
 	case WM8958:
 		return (selector * 100000) + 1000000;
+	case WM1811:
+		switch (selector) {
+		case 0:
+			return -EINVAL;
+		default:
+			return (selector * 100000) + 950000;
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -170,6 +178,11 @@ static int wm8994_ldo2_set_voltage(struct regulator_dev *rdev,
 	case WM8958:
 		selector = (min_uV - 1000000) / 100000;
 		break;
+	case WM1811:
+		selector = (min_uV - 950000) / 100000;
+		if (selector == 0)
+			selector = 1;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.7.6.3

