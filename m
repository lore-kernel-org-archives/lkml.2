Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab2EWBIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:08:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65281 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab2EWBIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:08:17 -0400
Message-ID: <1337735288.24555.1.camel@phoenix>
Subject: [PATCH] regulator: anatop: Use correct __devexit_p annotation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 23 May 2012 09:08:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__devexit functions are discarded when CONFIG_HOTPLUG
is not set, so the symbol needs to be referenced carefully.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/anatop-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 49b2112..8fbb6b6 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -226,7 +226,7 @@ static struct platform_driver anatop_regulator_driver = {
 		.of_match_table = of_anatop_regulator_match_tbl,
 	},
 	.probe	= anatop_regulator_probe,
-	.remove	= anatop_regulator_remove,
+	.remove	= __devexit_p(anatop_regulator_remove),
 };
 
 static int __init anatop_regulator_init(void)
-- 
1.7.5.4



