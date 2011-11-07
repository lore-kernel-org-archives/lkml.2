Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1KGDT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 22:19:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56917 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1KGDT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 22:19:26 -0500
Message-ID: <1320635954.10415.1.camel@phoenix>
Subject: [PATCH 1/2] mfd: include linux/module.h for ab5500-core
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 07 Nov 2011 11:19:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/module.h to fix below build error:

  CC      drivers/mfd/ab5500-core.o
drivers/mfd/ab5500-core.c:1419: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/mfd/ab5500-core.c:1437: error: expected declaration specifiers or '...' before string constant
drivers/mfd/ab5500-core.c:1437: warning: data definition has no type or storage class
drivers/mfd/ab5500-core.c:1437: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/mfd/ab5500-core.c:1437: warning: function declaration isn't a prototype
drivers/mfd/ab5500-core.c:1438: error: expected declaration specifiers or '...' before string constant
drivers/mfd/ab5500-core.c:1438: warning: data definition has no type or storage class
drivers/mfd/ab5500-core.c:1438: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/mfd/ab5500-core.c:1438: warning: function declaration isn't a prototype
drivers/mfd/ab5500-core.c:1439: error: expected declaration specifiers or '...' before string constant
drivers/mfd/ab5500-core.c:1439: warning: data definition has no type or storage class
drivers/mfd/ab5500-core.c:1439: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/mfd/ab5500-core.c:1439: warning: function declaration isn't a prototype
make[2]: *** [drivers/mfd/ab5500-core.o] Error 1
make[1]: *** [drivers/mfd] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I got the build error on linux-next 20111104.

 drivers/mfd/ab5500-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ab5500-core.c b/drivers/mfd/ab5500-core.c
index 4175544..ec10629 100644
--- a/drivers/mfd/ab5500-core.c
+++ b/drivers/mfd/ab5500-core.c
@@ -13,6 +13,7 @@
  * TODO: Event handling with irq_chip. Waiting for PRCMU fw support.
  */
 
+#include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
-- 
1.7.5.4



