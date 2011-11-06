Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1KFNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:16:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39338 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1KFNQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:16:58 -0500
Message-ID: <1320585411.18391.4.camel@phoenix>
Subject: [PATCH 2/2] hwspinlock/u8500: include linux/module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sun, 06 Nov 2011 21:16:51 +0800
In-Reply-To: <1320585256.18391.1.camel@phoenix>
References: <1320585256.18391.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include module.h to fix below build error:

  CC      drivers/hwspinlock/u8500_hsem.o
drivers/hwspinlock/u8500_hsem.c:177: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/hwspinlock/u8500_hsem.c:194: error: expected declaration specifiers or '...' before string constant
drivers/hwspinlock/u8500_hsem.c:194: warning: data definition has no type or storage class
drivers/hwspinlock/u8500_hsem.c:194: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/hwspinlock/u8500_hsem.c:194: warning: function declaration isn't a prototype
drivers/hwspinlock/u8500_hsem.c:195: error: expected declaration specifiers or '...' before string constant
drivers/hwspinlock/u8500_hsem.c:195: warning: data definition has no type or storage class
drivers/hwspinlock/u8500_hsem.c:195: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/hwspinlock/u8500_hsem.c:195: warning: function declaration isn't a prototype
drivers/hwspinlock/u8500_hsem.c:196: error: expected declaration specifiers or '...' before string constant
drivers/hwspinlock/u8500_hsem.c:196: warning: data definition has no type or storage class
drivers/hwspinlock/u8500_hsem.c:196: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/hwspinlock/u8500_hsem.c:196: warning: function declaration isn't a prototype
make[2]: *** [drivers/hwspinlock/u8500_hsem.o] Error 1
make[1]: *** [drivers/hwspinlock] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I got the build error on linux-next 20111104.
Axel
 drivers/hwspinlock/u8500_hsem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwspinlock/u8500_hsem.c b/drivers/hwspinlock/u8500_hsem.c
index a120f14..86980fe 100644
--- a/drivers/hwspinlock/u8500_hsem.c
+++ b/drivers/hwspinlock/u8500_hsem.c
@@ -21,6 +21,7 @@
  * General Public License for more details.
  */
 
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
-- 
1.7.5.4



