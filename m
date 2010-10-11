Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0JKQgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:36:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54888 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0JKQgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:36:08 -0400
From: Anand Gadiyar <gadiyar@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Anand Gadiyar <gadiyar@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: fix build when CONFIG_REGULATOR_DUMMY=n
Date: Mon, 11 Oct 2010 22:05:55 +0530
Message-Id: <1286814955-23415-1-git-send-email-gadiyar@ti.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f03f91826 (regulator: Add option for machine drivers
to enable the dummy regulator) in the regulators tree
seems to have introduced the following build break when
CONFIG_REGULATOR_DUMMY is disabled. Fix this.

  CC      drivers/regulator/dummy.o
drivers/regulator/dummy.c:41: error: redefinition of 'regulator_dummy_init'
drivers/regulator/dummy.h:28: note: previous definition of 'regulator_dummy_init' was here
make[2]: *** [drivers/regulator/dummy.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
The commit referenced above is in linux next as of 20101011
and breaks builds of the omap2plus_defconfig at least.

 drivers/regulator/dummy.h |    4 ----
 1 file changed, 4 deletions(-)

Index: mainline/drivers/regulator/dummy.h
===================================================================
--- mainline.orig/drivers/regulator/dummy.h
+++ mainline/drivers/regulator/dummy.h
@@ -22,10 +22,6 @@ struct regulator_dev;
 
 extern struct regulator_dev *dummy_regulator_rdev;
 
-#ifdef CONFIG_REGULATOR_DUMMY
 void __init regulator_dummy_init(void);
-#else
-static inline void regulator_dummy_init(void) { }
-#endif
 
 #endif
