Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab0HDGcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:32:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60567 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab0HDGcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Q9N71+X8fSdab27rQOfWzFZKP2l7BGYOTMAO793c5PuXPeBRutibBJ8b/sVLWkQALm
         O3h1CwsTp311TYW/NRzFV/WIVBPaD94OlySjbo0zpNiVLL/XQQstAoO3BNkpQM032aV1
         gymoRbFA5+J7OFpLpWcoq++N+VkKmkFzTJQBY=
Subject: [PATCH] max8998: fix off-by-one value range checking
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain
Date: Wed, 04 Aug 2010 14:34:10 +0800
Message-Id: <1280903650.8393.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In max8998_list_voltage() and max8998_set_voltage(),
we use ldo as array index of ldo_voltage_map.
Thus the valid range should be 0 .. ARRAY_SIZE(ldo_voltage_map)-1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 03e55a1..ab67298 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -119,7 +119,7 @@ static int max8998_list_voltage(struct regulator_dev *rdev,
 	int ldo = max8998_get_ldo(rdev);
 	int val;
 
-	if (ldo > ARRAY_SIZE(ldo_voltage_map))
+	if (ldo >= ARRAY_SIZE(ldo_voltage_map))
 		return -EINVAL;
 
 	desc = ldo_voltage_map[ldo];
@@ -306,7 +306,7 @@ static int max8998_set_voltage(struct regulator_dev *rdev,
 	u8 val;
 	bool en_ramp = false;
 
-	if (ldo > ARRAY_SIZE(ldo_voltage_map))
+	if (ldo >= ARRAY_SIZE(ldo_voltage_map))
 		return -EINVAL;
 
 	desc = ldo_voltage_map[ldo];
-- 
1.5.4.3



