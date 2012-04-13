Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2DMNfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:35:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52548 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2DMNfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:35:14 -0400
Message-ID: <1334324105.2732.2.camel@phoenix>
Subject: [PATCH] regulator: core: Fix getting input_uV when supplied by
 another regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 13 Apr 2012 21:35:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When supplied by another regulator, returns the supply regulator's output
voltage for inpu_uV.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4e34cd3..a8d4360 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -649,7 +649,7 @@ static void drms_uA_update(struct regulator_dev *rdev)
 	/* get input voltage */
 	input_uV = 0;
 	if (rdev->supply)
-		input_uV = _regulator_get_voltage(rdev);
+		input_uV = regulator_get_voltage(rdev->supply);
 	if (input_uV <= 0)
 		input_uV = rdev->constraints->input_uV;
 	if (input_uV <= 0)
-- 
1.7.5.4



