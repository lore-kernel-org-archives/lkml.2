Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1IGRRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:17:31 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55031 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1IGRR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:17:29 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, Armin Schindler <mac@melware.de>,
        Karsten Keil <isdn@linux-pingi.de>, Yong Zhang <yong.zhang0@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH 39/62] ISDN: irq: Remove IRQF_DISABLED
Date: Wed,  7 Sep 2011 16:10:36 +0800
Message-Id: <1315383059-3673-40-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and can be removed now.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/isdn/hardware/eicon/divasmain.c |    2 +-
 drivers/isdn/sc/init.c                  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/divasmain.c b/drivers/isdn/hardware/eicon/divasmain.c
index f332b60..8a0a831 100644
--- a/drivers/isdn/hardware/eicon/divasmain.c
+++ b/drivers/isdn/hardware/eicon/divasmain.c
@@ -481,7 +481,7 @@ void __inline__ outpp(void __iomem *addr, word p)
 int diva_os_register_irq(void *context, byte irq, const char *name)
 {
 	int result = request_irq(irq, diva_os_irq_wrapper,
-				 IRQF_DISABLED | IRQF_SHARED, name, context);
+				 IRQF_SHARED, name, context);
 	return (result);
 }
 
diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index ca710ab..a3127fb 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -336,7 +336,7 @@ static int __init sc_init(void)
 		 */
 		sc_adapter[cinst]->interrupt = irq[b];
 		if (request_irq(sc_adapter[cinst]->interrupt, interrupt_handler,
-				IRQF_DISABLED, interface->id,
+				0, interface->id,
 				(void *)(unsigned long) cinst))
 		{
 			kfree(sc_adapter[cinst]->channel);
-- 
1.7.4.1

