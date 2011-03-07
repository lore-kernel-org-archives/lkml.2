Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1CGJOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:14:36 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:50119 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243Ab1CGJOd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:14:33 -0500
From: Daniel WILLERUD <daniel.willerud@stericsson.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 7 Mar 2011 10:13:55 +0100
Subject: RE: [PATCH 3/5] mfd: free dangling irq in ab8500 gpadc probe error
 path
Thread-Topic: [PATCH 3/5] mfd: free dangling irq in ab8500 gpadc probe error
 path
Thread-Index: AcvbIpbB+o46TmwMQPSY+3RIJfG4wgBhUhDg
Message-ID: <757395B8DE5A844B80F3F4BE9867DDB64FAF4FA2AA@EXDCVYMBSTM006.EQ1STM.local>
References: <1299321987-6832-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1299321987-6832-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Daniel Willerud <daniel.willerud@stericsson.com>

-----Original Message-----
From: Linus WALLEIJ 
Sent: den 5 mars 2011 11:46
To: Samuel Ortiz; linux-kernel@vger.kernel.org
Cc: Lee Jones; Daniel WILLERUD; Linus Walleij
Subject: [PATCH 3/5] mfd: free dangling irq in ab8500 gpadc probe error path

From: Daniel Willerud <daniel.willerud@stericsson.com>

Signed-off-by: Daniel Willerud <daniel.willerud@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 178cbc5..b5b75b7 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -267,11 +267,13 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 	if (IS_ERR(gpadc->regu)) {
 		ret = PTR_ERR(gpadc->regu);
 		dev_err(gpadc->dev, "failed to get vtvout LDO\n");
-		goto fail;
+		goto fail_irq;
 	}
 	list_add_tail(&gpadc->node, &ab8500_gpadc_list);
 	dev_dbg(gpadc->dev, "probe success\n");
 	return 0;
+fail_irq:
+	free_irq(gpadc->irq, gpadc);
 fail:
 	kfree(gpadc);
 	gpadc = NULL;
-- 
1.7.3.2

