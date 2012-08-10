Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab2HJBcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:32:43 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61783 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab2HJBcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:32:41 -0400
Message-ID: <1344562353.2996.1.camel@phoenix>
Subject: [PATCH 1/6] regulator: core: Add checking n_voltages if using
 list_voltage() to read voltage regulators
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Fri, 10 Aug 2012 09:32:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_voltage() to read single voltage regulators should be only applied to
single voltage regulators, thus add checking n_voltages for this case.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0fffeae..5469f9f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2395,7 +2395,8 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
 		ret = rdev->desc->ops->list_voltage(rdev, sel);
 	} else if (rdev->desc->ops->get_voltage) {
 		ret = rdev->desc->ops->get_voltage(rdev);
-	} else if (rdev->desc->ops->list_voltage) {
+	} else if (rdev->desc->ops->list_voltage &&
+		   (rdev->desc->n_voltages == 1)) {
 		ret = rdev->desc->ops->list_voltage(rdev, 0);
 	} else {
 		return -EINVAL;
-- 
1.7.9.5



