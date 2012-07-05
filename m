Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2GENGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:06:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48465 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab2GENGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:06:46 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
Date: Thu,  5 Jul 2012 14:06:10 +0100
Message-Id: <1341493572-29735-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we can use any domain allocated IRQ, we need to first create a
map between the Hardware IRQ (hwirq) and the Linux Virtual IRQ (virq).
We do this with a helper function provided by the AB8500 IRQ domain
controller called ab8500_irq_get_virq(). We need to do this for both
IRQs which the Power-On-Key driver uses; one for button press, the other
for button depress.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/input/misc/ab8500-ponkey.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
index 5ceb23e..ae4b683 100644
--- a/drivers/input/misc/ab8500-ponkey.c
+++ b/drivers/input/misc/ab8500-ponkey.c
@@ -82,6 +82,7 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
 
 	input_set_capability(input, EV_KEY, KEY_POWER);
 
+	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, ponkey->irq_dbf);
 	error = request_any_context_irq(ponkey->irq_dbf, ab8500_ponkey_handler,
 					0, "ab8500-ponkey-dbf", ponkey);
 	if (error < 0) {
@@ -90,6 +91,7 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
 		goto err_free_mem;
 	}
 
+	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, ponkey->irq_dbr);
 	error = request_any_context_irq(ponkey->irq_dbr, ab8500_ponkey_handler,
 					0, "ab8500-ponkey-dbr", ponkey);
 	if (error < 0) {
-- 
1.7.9.5

