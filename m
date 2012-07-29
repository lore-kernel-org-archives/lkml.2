Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2G2XrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 19:47:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58394 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab2G2XrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 19:47:21 -0400
Message-ID: <1343605633.11323.1.camel@phoenix>
Subject: [PATCH] regulator: core: Add intermediate cast to uintptr_t before
 casting to pointer
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Mon, 30 Jul 2012 07:47:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to address the following warning during compilation time:

  CC      drivers/regulator/core.o
drivers/regulator/core.c: In function '_regulator_do_set_voltage':
drivers/regulator/core.c:2183:10: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f092588..41cbd74 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2180,7 +2180,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 
 	if (ret == 0 && best_val >= 0)
 		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
-				     (void *)best_val);
+				     (void *)(uintptr_t)best_val);
 
 	trace_regulator_set_voltage_complete(rdev_get_name(rdev), best_val);
 
-- 
1.7.9.5



