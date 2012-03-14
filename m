Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965320Ab2CNVkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:40:09 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35760 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031032Ab2CNVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:40:01 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        Marc Reilly <marc@cpdesign.com.au>
Subject: [PATCH v3 1/6] regmap: add support for 7_25 format
Date: Thu, 15 Mar 2012 07:43:05 +1100
Message-Id: <1331757790-10583-2-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331757790-10583-1-git-send-email-marc@cpdesign.com.au>
References: <1331757790-10583-1-git-send-email-marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for devices with 7 address bits and 25 data bits.
The initial intended user for this are the mc13xxx mfds in spi mode.
(The 25th data bit is actually a dummy bit)

Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
---
 drivers/base/regmap/regmap.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index be10a4f..62ef0df 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -100,6 +100,14 @@ static void regmap_format_10_14_write(struct regmap *map,
 	out[0] = reg >> 2;
 }
 
+static void regmap_format_7_25_write(struct regmap *map,
+				    unsigned int reg, unsigned int val)
+{
+	__be32 *out = map->work_buf;
+
+	*out = (reg << 25) | val;
+}
+
 static void regmap_format_8(void *buf, unsigned int val)
 {
 	u8 *b = buf;
@@ -193,6 +201,9 @@ struct regmap *regmap_init(struct device *dev,
 		case 9:
 			map->format.format_write = regmap_format_7_9_write;
 			break;
+		case 25:
+			map->format.format_write = regmap_format_7_25_write;
+			break;
 		default:
 			goto err_map;
 		}
-- 
1.7.3.4

