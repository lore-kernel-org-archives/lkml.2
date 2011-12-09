Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1LID2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 22:28:09 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50295 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1LID2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 22:28:06 -0500
Message-ID: <1323401275.25140.0.camel@phoenix>
Subject: [PATCH 1/2] mfd: jz4740-adc: Include linux/io.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Samuel Ortiz <sameo@linux.intel.com>
Date: Fri, 09 Dec 2011 11:27:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/io.h to fix below build error:

  CC      drivers/mfd/jz4740-adc.o
drivers/mfd/jz4740-adc.c: In function 'jz4740_adc_irq_demux':
drivers/mfd/jz4740-adc.c:73: error: implicit declaration of function 'readb'
drivers/mfd/jz4740-adc.c: In function 'jz4740_adc_set_enabled':
drivers/mfd/jz4740-adc.c:110: error: implicit declaration of function 'writeb'
drivers/mfd/jz4740-adc.c: In function 'jz4740_adc_set_config':
drivers/mfd/jz4740-adc.c:146: error: implicit declaration of function 'readl'
drivers/mfd/jz4740-adc.c:151: error: implicit declaration of function 'writel'
drivers/mfd/jz4740-adc.c: In function 'jz4740_adc_probe':
drivers/mfd/jz4740-adc.c:249: error: implicit declaration of function 'ioremap_nocache'
drivers/mfd/jz4740-adc.c:249: warning: assignment makes pointer from integer without a cast
drivers/mfd/jz4740-adc.c:289: warning: passing argument 3 of 'mfd_add_devices' discards qualifiers from pointer target type
include/linux/mfd/core.h:93: note: expected 'struct mfd_cell *' but argument is of type 'const struct mfd_cell *'
drivers/mfd/jz4740-adc.c:299: error: implicit declaration of function 'iounmap'
make[2]: *** [drivers/mfd/jz4740-adc.o] Error 1
make[1]: *** [drivers/mfd] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/jz4740-adc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 1e9ee53..ef39528 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
-- 
1.7.5.4



