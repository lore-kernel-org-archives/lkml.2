Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2BXPFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:05:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37575 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2BXPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:05:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.224.9 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330095894.5102.1.camel@phoenix>
Subject: [PATCH v2] regulator: Set delay to 0 if set_voltage_time_sel
 callback returns error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 24 Feb 2012 23:04:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdev->desc->ops->set_voltage_time_sel may return negative error code.
Set delay to 0 and also show warning if set_voltage_time_sel returns error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v2: show warning message if set_voltage_time_sel returns error.

 drivers/regulator/core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index beeeb7f..19a4778 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1892,6 +1892,10 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 			old_selector = ret;
 			delay = rdev->desc->ops->set_voltage_time_sel(rdev,
 						old_selector, selector);
+			if (delay < 0) {
+				rdev_warn(rdev, "set_voltage_time_sel() failed: %d\n", delay);
+				delay = 0;
+			}
 		}
 
 		if (best_val != INT_MAX) {
-- 
1.7.5.4



