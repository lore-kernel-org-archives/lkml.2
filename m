Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab2HYT5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:57:22 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:2649 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757554Ab2HYT5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:57:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="153817998"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: kernel-janitors@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] drivers/iio/adc/at91_adc.c: adjust inconsistent IS_ERR and PTR_ERR
Date: Sat, 25 Aug 2012 21:57:09 +0200
Message-Id: <1345924629-16584-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Change the call to PTR_ERR to access the value just tested by IS_ERR.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
@@

(
if (IS_ERR(e)) { ... PTR_ERR(e) ... }
|
if (IS_ERR(e=e1)) { ... PTR_ERR(e) ... }
|
*if (IS_ERR(e))
 { ...
*  PTR_ERR(e1)
   ... }
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/iio/adc/at91_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 98c96f9..8650281 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -604,7 +604,7 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
 	st->adc_clk = devm_clk_get(&pdev->dev, "adc_op_clk");
 	if (IS_ERR(st->adc_clk)) {
 		dev_err(&pdev->dev, "Failed to get the ADC clock.\n");
-		ret = PTR_ERR(st->clk);
+		ret = PTR_ERR(st->adc_clk);
 		goto error_disable_clk;
 	}
 

