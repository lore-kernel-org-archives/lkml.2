Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1IVJHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:07:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39135 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1IVJHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:07:10 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andres Salomon <dilinger@queued.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <dagenaisj@sonatest.com>,
        Tony Lindgren <tony@atomide.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Julia Lawall <julia@diku.dk>
Subject: [PATCH 50/55] w1: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:59:17 +0800
Message-Id: <1316681962-8217-51-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/masters/ds1wm.c    |    2 +-
 drivers/w1/masters/omap_hdq.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index a0c8965..9fa6844 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -502,7 +502,7 @@ static int ds1wm_probe(struct platform_device *pdev)
 		irq_set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
 
 	ret = request_irq(ds1wm_data->irq, ds1wm_isr,
-			IRQF_DISABLED | IRQF_SHARED, "ds1wm", ds1wm_data);
+			IRQF_SHARED, "ds1wm", ds1wm_data);
 	if (ret)
 		goto err1;
 
diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 5ef385b..d1ef89d 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -633,7 +633,7 @@ static int __devinit omap_hdq_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	ret = request_irq(irq, hdq_isr, IRQF_DISABLED, "omap_hdq", hdq_data);
+	ret = request_irq(irq, hdq_isr, 0, "omap_hdq", hdq_data);
 	if (ret < 0) {
 		dev_dbg(&pdev->dev, "could not request irq\n");
 		goto err_irq;
-- 
1.7.4.1

