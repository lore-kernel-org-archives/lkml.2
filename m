Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2I0Xg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 19:36:29 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:61895 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2I0Xg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 19:36:28 -0400
Message-ID: <1348788977.8055.1.camel@phoenix>
Subject: [PATCH] extcon: adc-jack: Fix checking return value of
 request_any_context_irq
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        anish kumar <anish.singh@samsung.com>
Date: Fri, 28 Sep 2012 07:36:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On failure, request_any_context_irq() returns a negative value.
On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.

Also ensure adc_jack_probe() return 0 on success.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/extcon/extcon-adc-jack.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 725eb5a..2cc6bec 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -161,13 +161,12 @@ static int __devinit adc_jack_probe(struct platform_device *pdev)
 	err = request_any_context_irq(data->irq, adc_jack_irq_thread,
 			pdata->irq_flags, pdata->name, data);
 
-	if (err) {
+	if (err < 0) {
 		dev_err(&pdev->dev, "error: irq %d\n", data->irq);
-		err = -EINVAL;
 		goto err_irq;
 	}
 
-	goto out;
+	return 0;
 
 err_irq:
 	extcon_dev_unregister(&data->edev);
-- 
1.7.9.5



