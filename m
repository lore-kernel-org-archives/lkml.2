Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1H3K0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:26:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33037 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H3K0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:26:18 -0400
Subject: [PATCH] rtc: imxdi: Add missing include of linux/sched.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>, Wan ZongShun <mcuos.com@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 18:26:07 +0800
Message-ID: <1314699967.19440.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/sched.h to fix below build error.

  CC      drivers/rtc/rtc-imxdi.o
drivers/rtc/rtc-imxdi.c: In function 'di_write_wait':
drivers/rtc/rtc-imxdi.c:168: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/rtc/rtc-imxdi.c:168: error: (Each undeclared identifier is reported only once
drivers/rtc/rtc-imxdi.c:168: error: for each function it appears in.)
drivers/rtc/rtc-imxdi.c:168: error: implicit declaration of function 'signal_pending'
drivers/rtc/rtc-imxdi.c:168: error: implicit declaration of function 'schedule_timeout'
drivers/rtc/rtc-imxdi.c: In function 'dryice_norm_irq':
drivers/rtc/rtc-imxdi.c:329: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
make[2]: *** [drivers/rtc/rtc-imxdi.o] Error 1
make[1]: *** [drivers/rtc] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-imxdi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 2dd3c01..d93a960 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
+#include <linux/sched.h>
 #include <linux/workqueue.h>
 
 /* DryIce Register Definitions */
-- 
1.7.4.1



