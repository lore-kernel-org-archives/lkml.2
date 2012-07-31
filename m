Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2GaN2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:28:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45138 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2GaN2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:28:35 -0400
Message-ID: <1343741306.6773.1.camel@phoenix>
Subject: [PATCH] regulator: wm831x-ldo: Check return value of
 wm831x_reg_read()
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2012 21:28:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm831x_reg_read() returns negative error code on failure.
This prevents using the error code as the value read.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-ldo.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 5cb70ca..56a6de3 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -205,6 +205,8 @@ static int wm831x_gp_ldo_get_status(struct regulator_dev *rdev)
 
 	/* Is it reporting under voltage? */
 	ret = wm831x_reg_read(wm831x, WM831X_LDO_UV_STATUS);
+	if (ret < 0)
+		return ret;
 	if (ret & mask)
 		return REGULATOR_STATUS_ERROR;
 
@@ -469,6 +471,8 @@ static int wm831x_aldo_get_status(struct regulator_dev *rdev)
 
 	/* Is it reporting under voltage? */
 	ret = wm831x_reg_read(wm831x, WM831X_LDO_UV_STATUS);
+	if (ret < 0)
+		return ret;
 	if (ret & mask)
 		return REGULATOR_STATUS_ERROR;
 
-- 
1.7.9.5



