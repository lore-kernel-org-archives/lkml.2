Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193Ab2DMKtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:49:39 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42077 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2DMKth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:49:37 -0400
Message-ID: <1334314167.4244.1.camel@phoenix>
Subject: [PATCH] regulator: core: Add checking set_mode callback in
 regulator_set_optimum_mode
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 13 Apr 2012 18:49:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_set_optimum_mode needs set_mode to properly work.
Add checking for set_mode callback in case it may be not implemented.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1bd71a8..f241671 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2340,6 +2340,11 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	 */
 	ret = -EINVAL;
 
+	if (!rdev->desc->ops->set_mode) {
+		rdev_err(rdev, "no set_mode operation\n");
+		goto out;
+	}
+
 	/* get output voltage */
 	output_uV = _regulator_get_voltage(rdev);
 	if (output_uV <= 0) {
-- 
1.7.5.4



