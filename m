Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1FFU4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:56:20 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:60184 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab1FFU4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:56:19 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1307393740!21667047!18
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] misc: atmel_pwm: use resource_size()
Date: Mon, 6 Jun 2011 13:55:39 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106061355.39285.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
index 0f3fb4f..28f5aaa 100644
--- a/drivers/misc/atmel_pwm.c
+++ b/drivers/misc/atmel_pwm.c
@@ -329,7 +329,7 @@ static int __init pwm_probe(struct platform_device *pdev)
 	p->pdev = pdev;
 	p->mask = *mp;
 	p->irq = irq;
-	p->base = ioremap(r->start, r->end - r->start + 1);
+	p->base = ioremap(r->start, resource_size(r));
 	if (!p->base)
 		goto fail;
 	p->clk = clk_get(&pdev->dev, "pwm_clk");
