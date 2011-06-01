Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab1FAWTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:19:50 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:59409 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab1FAWTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:19:49 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1306966769!6743707!9
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] misc: atmel-ssc: use resource_size
Date: Wed, 1 Jun 2011 15:19:31 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106011519.31929.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 4afffe6..769a4e8 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -95,7 +95,7 @@ static int __init ssc_probe(struct platform_device *pdev)
 	}
 
 	ssc->pdev = pdev;
-	ssc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	ssc->regs = ioremap(regs->start, resource_size(regs));
 	if (!ssc->regs) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
 		retval = -EINVAL;
