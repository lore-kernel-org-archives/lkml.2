Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab2KPJJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:09:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33003 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2KPJJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:09:32 -0500
Message-ID: <1353056962.4277.2.camel@phoenix>
Subject: [PATCH RESEND] power: generic-adc-battery: Fix checking return
 value of request_any_context_irq
From: Axel Lin <axel.lin@ingics.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Jonathan Cameron <jic23@kernel.org>,
        anish kumar <anish198519851985@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 16 Nov 2012 17:09:22 +0800
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
This was sent on https://lkml.org/lkml/2012/10/11/77
Nobody picks up this patch, so resend it.
I think this patch is for 3.7.

Regards,
Axel
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



