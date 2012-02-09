Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab2BINmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:42:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59940 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab2BINmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:42:12 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Complain if a voltage range is specified but can't be used
Date: Thu,  9 Feb 2012 13:42:06 +0000
Message-Id: <1328794926-4892-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
In-Reply-To: <1328794926-4892-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1328794926-4892-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make much sense to specify a range of voltages consumers can
use if they haven't been given permission to change the voltage. Log if
this happens, probably the user forgot to specify CHANGE_VOLTAGE.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 68acc2f..5ba25c0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -805,6 +805,11 @@ static void print_constraints(struct regulator_dev *rdev)
 		count += sprintf(buf + count, "standby");
 
 	rdev_info(rdev, "%s\n", buf);
+
+	if ((constraints->min_uV != constraints->max_uV) &&
+	    !(constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE))
+		rdev_warn(rdev,
+			  "Voltage range but no REGULATOR_CHANGE_VOLTAGE\n");
 }
 
 static int machine_constraints_voltage(struct regulator_dev *rdev,
-- 
1.7.9.rc1

