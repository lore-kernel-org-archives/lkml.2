Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2DKMRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:17:09 -0400
Received: from smtp3.em.euronet.nl ([194.134.4.234]:57322 "EHLO
	smtp3.em.euronet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab2DKMRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:17:07 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2012 08:17:07 EDT
From: Rini van Zetten <rini@arvoo.nl>
Cc: galak@kernel.crashing.org, linux-kernel@vger.kernel.org,
        Rini van Zetten <rini@arvoo.nl>
Subject: [PATCH 1/1] fix crash when no irq_eoi function is available
Date: Wed, 11 Apr 2012 14:09:45 +0200
Message-Id: <1334146185-11910-1-git-send-email-rini@arvoo.nl>
X-Mailer: git-send-email 1.7.4.1
X-ARVOO-MailScanner-ID: 10BD2714A7.B7E24
X-ARVOO-MailScanner: Found to be clean
X-ARVOO-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.9, required 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90)
X-ARVOO-MailScanner-From: rini@arvoo.nl
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Rini van Zetten <rini@arvoo.nl>
---
 drivers/gpio/gpio-mpc8xxx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 5cd04b6..edcffd6 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -163,7 +163,8 @@ static void mpc8xxx_gpio_irq_cascade(unsigned int irq, struct irq_desc *desc)
 	if (mask)
 		generic_handle_irq(irq_linear_revmap(mpc8xxx_gc->irq,
 						     32 - ffs(mask)));
-	chip->irq_eoi(&desc->irq_data);
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
 }
 
 static void mpc8xxx_irq_unmask(struct irq_data *d)
-- 
1.7.4.1

