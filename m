Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab1KXDK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:10:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50494 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab1KXDK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:10:58 -0500
Message-ID: <1322104251.16201.8.camel@phoenix>
Subject: [PATCH] spi: nuc900: Include linux/module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        spi-devel-general@lists.sourceforge.net
Date: Thu, 24 Nov 2011 11:10:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/module.h to fix below build error:

  CC      drivers/spi/spi-nuc900.o
drivers/spi/spi-nuc900.c:484: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/spi/spi-nuc900.c:489: error: expected declaration specifiers or '...' before string constant
drivers/spi/spi-nuc900.c:489: warning: data definition has no type or storage class
drivers/spi/spi-nuc900.c:489: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/spi/spi-nuc900.c:489: warning: function declaration isn't a prototype
drivers/spi/spi-nuc900.c:490: error: expected declaration specifiers or '...' before string constant
drivers/spi/spi-nuc900.c:490: warning: data definition has no type or storage class
drivers/spi/spi-nuc900.c:490: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/spi/spi-nuc900.c:490: warning: function declaration isn't a prototype
drivers/spi/spi-nuc900.c:491: error: expected declaration specifiers or '...' before string constant
drivers/spi/spi-nuc900.c:491: warning: data definition has no type or storage class
drivers/spi/spi-nuc900.c:491: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/spi/spi-nuc900.c:491: warning: function declaration isn't a prototype
drivers/spi/spi-nuc900.c:492: error: expected declaration specifiers or '...' before string constant
drivers/spi/spi-nuc900.c:492: warning: data definition has no type or storage class
drivers/spi/spi-nuc900.c:492: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS'
drivers/spi/spi-nuc900.c:492: warning: function declaration isn't a prototype
make[2]: *** [drivers/spi/spi-nuc900.o] Error 1
make[1]: *** [drivers/spi] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/spi/spi-nuc900.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-nuc900.c b/drivers/spi/spi-nuc900.c
index 21c70b2..182e9c8 100644
--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -8,6 +8,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
-- 
1.7.5.4



