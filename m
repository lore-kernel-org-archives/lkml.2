Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2DPKoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:44:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42961 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2DPKob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:44:31 -0400
Message-ID: <1334573063.2673.2.camel@phoenix>
Subject: [PATCH v2] regulator: core: Add checking set_mode callback in
 regulator_set_optimum_mode
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Stephen Boyd <sboyd@codeaurora.org>
Date: Mon, 16 Apr 2012 18:44:23 +0800
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
 drivers/regulator/core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f68b22a..de8ad8f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2340,6 +2340,9 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	 */
 	ret = -EINVAL;
 
+	if (!rdev->desc->ops->set_mode)
+		goto out;
+
 	/* get output voltage */
 	output_uV = _regulator_get_voltage(rdev);
 	if (output_uV <= 0) {
-- 
1.7.5.4



