Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2HUJhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:37:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62807 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2HUJhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:37:20 -0400
Message-ID: <1345541833.17239.0.camel@phoenix>
Subject: [PATCH] gpio: bt8xx: Fix build error due to missing include file
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Buesch <m@bues.ch>, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 21 Aug 2012 17:37:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below build error:

  CC [M]  drivers/gpio/gpio-bt8xx.o
drivers/gpio/gpio-bt8xx.c:53:40: fatal error: ../media/video/bt8xx/bt848.h: No such file or directory
compilation terminated.
make[2]: *** [drivers/gpio/gpio-bt8xx.o] Error 1
make[1]: *** [drivers/gpio] Error 2
make: *** [drivers] Error 2

drivers/media/video/bt8xx/bt848.h is moved to drivers/media/pci/bt8xx/bt848.h
by commit 68de959f773a1d49096835c411390bceff5d1549
"[media] bt8xx: move analog TV part to be together with DTV one".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/gpio/gpio-bt8xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
index e4cc7eb..92d555d 100644
--- a/drivers/gpio/gpio-bt8xx.c
+++ b/drivers/gpio/gpio-bt8xx.c
@@ -50,7 +50,7 @@
 #include <linux/slab.h>
 
 /* Steal the hardware definitions from the bttv driver. */
-#include "../media/video/bt8xx/bt848.h"
+#include "../media/pci/bt8xx/bt848.h"
 
 
 #define BT8XXGPIO_NR_GPIOS		24 /* We have 24 GPIO pins */
-- 
1.7.9.5



