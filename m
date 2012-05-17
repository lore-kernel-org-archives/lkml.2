Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978Ab2EQDgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:36:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59936 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760937Ab2EQDgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:36:03 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH -next] rtc-twl: pass IRQF_ONESHOT to request_threaded_irq
Date: Thu, 17 May 2012 11:35:49 +0800
Message-Id: <1337225749-7106-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flag of IRQF_ONESHOT should be passed to request_threaded_irq,
otherwise the following failure message will be dumped because
hardware handler is defined as NULL:

[    3.329864] genirq: Threaded irq requested with handler=NULL and
!ONESHOT for irq 363
[    3.338226] twl_rtc twl_rtc: IRQ is not free.
[    3.346099] twl_rtc: probe of twl_rtc failed with error -22

The patch fixes the rtc-twl probe failure.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/rtc/rtc-twl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 258abea..c5d06fe 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -510,7 +510,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
-				   IRQF_TRIGGER_RISING,
+				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 				   dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
-- 
1.7.9.5

