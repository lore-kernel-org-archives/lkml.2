Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2G2HxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 03:53:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43201 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2G2HxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 03:53:24 -0400
Message-ID: <1343548396.9481.1.camel@phoenix>
Subject: [PATCH] regulator: core: Fix argument to _notifier_call_chain call
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sun, 29 Jul 2012 15:53:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the address of best_val rather than the value of best_val for the third
argument to _notifier_call_chain().

This fixes below build warning:
  CC      drivers/regulator/core.o
drivers/regulator/core.c: In function '_regulator_do_set_voltage':
drivers/regulator/core.c:2183:10: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f092588..37ce62b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2180,7 +2180,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 
 	if (ret == 0 && best_val >= 0)
 		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
-				     (void *)best_val);
+				     (void *)&best_val);
 
 	trace_regulator_set_voltage_complete(rdev_get_name(rdev), best_val);
 
-- 
1.7.9.5



