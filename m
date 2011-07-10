Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1GJKwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:52:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48626 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1GJKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:52:12 -0400
Subject: [PATCH] regulator: tps65910: Fix a memory leak in tps65910_probe
 error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 18:52:07 +0800
Message-ID: <1310295127.4877.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak if chip id is not matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index fe8dc02..e15aac6 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -909,6 +909,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		break;
 	default:
 		pr_err("Invalid tps chip version\n");
+		kfree(pmic);
 		return -ENODEV;
 	}
 
-- 
1.7.4.1



