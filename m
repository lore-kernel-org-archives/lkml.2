Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2GPHfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:35:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34990 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2GPHfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:35:41 -0400
Message-ID: <5003C449.6000806@linaro.org>
Date: Mon, 16 Jul 2012 08:35:37 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <4FF6994B.9040801@linaro.org> <20120706173957.GA10202@core.coreip.homeip.net> <4FFB288D.4080606@linaro.org> <20120709201422.GA12242@core.coreip.homeip.net> <4FFB40A4.5060505@linaro.org> <20120709204620.GA12692@core.coreip.homeip.net> <4FFB463F.9040201@linaro.org> <20120710061757.GB29257@core.coreip.homeip.net>
In-Reply-To: <20120710061757.GB29257@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it would be best if this got merged through whatever tree that
> was used to introduce ab8500_irq_get_virq(); otherwise it will have to
> wait till I resync with mainline sometime in the middle of the next
> release cycle.

I agree. Sam that's you, patch below. :)

From: Lee Jones <lee.jones@linaro.org>
Date: Tue, 26 Jun 2012 10:46:50 +0100
Subject: [PATCH 1/1] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping

Before we can use any domain allocated IRQ, we need to first create a
map between the Hardware IRQ (hwirq) and the Linux Virtual IRQ (virq).
We do this with a helper function provided by the AB8500 IRQ domain
controller called ab8500_irq_get_virq(). We need to do this for both
IRQs which the Power-On-Key driver uses; one for button press, the other
for button depress.

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/input/misc/ab8500-ponkey.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
index 350fd0c..1a1d974 100644
--- a/drivers/input/misc/ab8500-ponkey.c
+++ b/drivers/input/misc/ab8500-ponkey.c
@@ -73,8 +73,8 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
 
 	ponkey->idev = input;
 	ponkey->ab8500 = ab8500;
-	ponkey->irq_dbf = irq_dbf;
-	ponkey->irq_dbr = irq_dbr;
+	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, irq_dbf);
+	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, irq_dbr);
 
 	input->name = "AB8500 POn(PowerOn) Key";
 	input->dev.parent = &pdev->dev;
-- 
1.7.9.5
