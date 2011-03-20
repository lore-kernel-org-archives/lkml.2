Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1CTMXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 08:23:21 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:56258 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1CTMXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 08:23:19 -0400
Date: Sun, 20 Mar 2011 13:23:16 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lauri Leukkunen <lauri.leukkunen@nokia.com>,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        Srikar <ext-srikar.1.bhavanarayana@nokia.com>,
        Dmitry Torokhov <dtor@mail.ru>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH] input: TOUCHSCREEN_TSC2005 should depend on
 GENERIC_HARDIRQS
Message-ID: <alpine.DEB.2.00.1103201312320.6633@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/input/touchscreen/tsc2005.c: In function ¡tsc2005_probe¢:
drivers/input/touchscreen/tsc2005.c:666: error: implicit declaration of function ¡set_irq_wake¢

In addition, migrate from set_irq_wake() (marked "do not use" as of commit
a0cd9ca2b907d7ee26575e7b63ac92dad768a75e ("genirq: Namespace cleanup")) to
irq_set_irq_wake().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/touchscreen/Kconfig   |    2 +-
 drivers/input/touchscreen/tsc2005.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 112ec55..434fd80 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -641,7 +641,7 @@ config TOUCHSCREEN_TOUCHIT213
 
 config TOUCHSCREEN_TSC2005
         tristate "TSC2005 based touchscreens"
-        depends on SPI_MASTER
+        depends on SPI_MASTER && GENERIC_HARDIRQS
         help
           Say Y here if you have a TSC2005 based touchscreen.
 
diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 8742061..437b9cd 100644
--- a/drivers/input/touchscreen/tsc2005.c
+++ b/drivers/input/touchscreen/tsc2005.c
@@ -663,7 +663,7 @@ static int __devinit tsc2005_probe(struct spi_device *spi)
 		goto err_remove_sysfs;
 	}
 
-	set_irq_wake(spi->irq, 1);
+	irq_set_irq_wake(spi->irq, 1);
 	return 0;
 
 err_remove_sysfs:
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
