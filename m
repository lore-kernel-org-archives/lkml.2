Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1GaXmC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 19:42:02 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48371 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1GaXlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 19:41:55 -0400
Subject: [PATCH] power_supply: max8998_charger: allow full timeout not set,
 leave it unchanged
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Donggeun Kim <dg77.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 07:41:50 +0800
Message-ID: <1312155710.2445.7.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing break for case 0 of pdata->timeout, otherwise it will fall
through to the default case and return error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/max8998_charger.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
index 4ddacb4..f793711 100644
--- a/drivers/power/max8998_charger.c
+++ b/drivers/power/max8998_charger.c
@@ -152,6 +152,7 @@ static __devinit int max8998_battery_probe(struct platform_device *pdev)
 	case 0:
 		dev_dbg(max8998->dev,
 			"Full Timeout not set: leave it unchanged.\n");
+		break;
 	default:
 		dev_err(max8998->dev, "Invalid Full Timeout value\n");
 		ret = -EINVAL;
-- 
1.7.4.1



