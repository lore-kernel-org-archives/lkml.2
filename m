Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2JKISo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:18:44 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59604 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2JKISi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:18:38 -0400
Message-ID: <1349943507.27003.0.camel@phoenix>
Subject: [PATCH] power: generic-adc-battery: Fix checking return value of
 request_any_context_irq
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Anton Vorontsov <cbou@mail.ru>, anish kumar <anish198519851985@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 16:18:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On failure, request_any_context_irq() returns a negative value.
On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/power/generic-adc-battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index 9bdf444..4a00ef7 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -327,7 +327,7 @@ static int __devinit gab_probe(struct platform_device *pdev)
 		ret = request_any_context_irq(irq, gab_charged,
 				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				"battery charged", adc_bat);
-		if (ret)
+		if (ret < 0)
 			goto err_gpio;
 	}
 
-- 
1.7.9.5



