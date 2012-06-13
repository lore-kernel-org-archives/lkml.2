Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2FMO5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:57:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58618 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2FMO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:57:38 -0400
Message-ID: <1339599444.8531.1.camel@phoenix>
Subject: [PATCH] regmap: mmio: Staticize regmap_mmio_gen_context()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 13 Jun 2012 22:57:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap_mmio_gen_context() is only used in regmap-mmio.c. Thus make it static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/base/regmap/regmap-mmio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index eec8663..d64a7fc 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -128,7 +128,7 @@ static struct regmap_bus regmap_mmio = {
 	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
 };
 
-struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
+static struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
 					const struct regmap_config *config)
 {
 	struct regmap_mmio_context *ctx;
-- 
1.7.9.5



