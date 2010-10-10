Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab0JJR2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:28:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab0JJR2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=u/qp9c+cbDI9qIH5dXqx6EY20isRwsMGeHAsYb/YNezjxcKliq89qz/BpdQgYrOT2B
         It/q4L/4FLCLceb/ti4NPaFDxGsn+ShppvdAqtmm7bbMUtwK7zd81GuZh68y/MbwmuAu
         m9dlougmOJVu+vYnXcJyp4L2mcldfowXliwJ8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sh: boards/mach-x3proto: gpio: fix error handling code
Date: Sun, 10 Oct 2010 21:28:27 +0400
Message-Id: <1286731708-17822-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks for (irq < 0) and (ilsel < 0) didn't make sense since they were
unsigned.  Made them signed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested.

 arch/sh/boards/mach-x3proto/gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/boards/mach-x3proto/gpio.c b/arch/sh/boards/mach-x3proto/gpio.c
index 9fcd7ce..594adf7 100644
--- a/arch/sh/boards/mach-x3proto/gpio.c
+++ b/arch/sh/boards/mach-x3proto/gpio.c
@@ -79,7 +79,7 @@ struct gpio_chip x3proto_gpio_chip = {
 
 int __init x3proto_gpio_setup(void)
 {
-	unsigned int ilsel;
+	int ilsel;
 	int ret, i;
 
 	ilsel = ilsel_enable(ILSEL_KEY);
@@ -92,7 +92,7 @@ int __init x3proto_gpio_setup(void)
 
 	for (i = 0; i < NR_BASEBOARD_GPIOS; i++) {
 		unsigned long flags;
-		unsigned int irq = create_irq();
+		int irq = create_irq();
 
 		if (unlikely(irq < 0)) {
 			ret = -EINVAL;
-- 
1.7.0.4

