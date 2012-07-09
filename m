Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2GISxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:53:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65520 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2GISxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:53:06 -0400
Message-ID: <4FFB288D.4080606@linaro.org>
Date: Mon, 09 Jul 2012 20:53:01 +0200
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <4FF6994B.9040801@linaro.org> <20120706173957.GA10202@core.coreip.homeip.net>
In-Reply-To: <20120706173957.GA10202@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>
Date: Tue, 26 Jun 2012 10:46:50 +0100
Subject: [PATCH 1/1] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping

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
index 5ceb23e..08d42d1 100644
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
 
+	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, ponkey->irq_dbr);
 	error = request_any_context_irq(ponkey->irq_dbr, ab8500_ponkey_handler,
 					0, "ab8500-ponkey-dbr", ponkey);
 	if (error < 0) {
-- 
1.7.9.5


