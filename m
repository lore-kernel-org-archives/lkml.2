Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2IHKxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 06:53:36 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:34105 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017Ab2IHKxb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 06:53:31 -0400
From: Yunfan Zhang <yfzhang@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 8 Sep 2012 03:53:25 -0700
Subject: [PATCH] regmap: no need primary handler for nested irq
Thread-Topic: [PATCH] regmap: no need primary handler for nested irq
Thread-Index: Ac2NsCv8/jUtjMwjRdqXSD8VRAfsig==
Message-ID: <4737A960563B524DA805CA602BE04B3064CC590646@SC-VEXCH2.marvell.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The primary handler will NOT be called if the interrupt nests into
another interrupt thread. Remove it to avoid confusing.

Signed-off-by: Yunfan Zhang <yfzhang@marvell.com>
---
 drivers/base/regmap/regmap-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index c9ff9f0..5972ad9 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -226,7 +226,7 @@ static int regmap_irq_map(struct irq_domain *h, unsigned int virq,
 	struct regmap_irq_chip_data *data = h->host_data;
 
 	irq_set_chip_data(virq, data);
-	irq_set_chip_and_handler(virq, &data->irq_chip, handle_edge_irq);
+	irq_set_chip(virq, &data->irq_chip);
 	irq_set_nested_thread(virq, 1);
 
 	/* ARM needs us to explicitly flag the IRQ as valid
-- 
1.7.0.4

