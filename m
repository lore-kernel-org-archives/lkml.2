Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768445Ab2KOQfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:35:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40825 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768407Ab2KOQfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:35:20 -0500
Message-ID: <1352997314.10636.3.camel@phoenix>
Subject: [PATCH RFT] regulator: da9055: Fix checking wrong value in
 da9055_gpio_init
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 00:35:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check pdata->gpio_rsel && pdata->gpio_rsel[id] for the case GPI pin is muxed
with regulator to select the regulator register set A/B for voltage ramping.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Ashish,
I'm wondering if this is a typo or I misunderstand the code.
Axel
 drivers/regulator/da9055-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 8994178..79c5665 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -501,7 +501,7 @@ static __devinit int da9055_gpio_init(struct da9055_regulator *regulator,
 			goto err;
 	}
 
-	if (pdata->gpio_rsel && pdata->gpio_ren[id]) {
+	if (pdata->gpio_rsel && pdata->gpio_rsel[id]) {
 		char name[18];
 		int gpio_mux = pdata->gpio_rsel[id];
 
-- 
1.7.9.5



