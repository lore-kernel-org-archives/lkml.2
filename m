Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1LIUdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:33:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51653 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1LIUcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:32:47 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH 2/4] spi/nuc900: Include linux/module.h
Date: Fri,  9 Dec 2011 21:32:33 +0100
Message-Id: <1323462755-14369-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1323462755-14369-1-git-send-email-w.sang@pengutronix.de>
References: <1323462755-14369-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>

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
Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
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
1.7.2.5

