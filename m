Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab2ILM4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:56:00 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:16819 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab2ILMzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBXkQIDFXBhOIEbxikVIDlV+JM4lU
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511780"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 16/24] Staging: ipack: Let interrupts return irqreturn_t.
Date: Wed, 12 Sep 2012 14:55:38 +0200
Message-Id: <1347454546-23236-16-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    2 +-
 drivers/staging/ipack/bridges/tpci200.h |    3 +--
 drivers/staging/ipack/devices/ipoctal.c |    2 +-
 drivers/staging/ipack/ipack.h           |    4 +++-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index b0d2205..1a149d8 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -193,7 +193,7 @@ static int tpci200_free_irq(struct ipack_device *dev)
 }
 
 static int tpci200_request_irq(struct ipack_device *dev, int vector,
-			       int (*handler)(void *), void *arg)
+			       irqreturn_t (*handler)(void *), void *arg)
 {
 	int res = 0;
 	struct slot_irq *slot_irq;
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index b8e9826..2718d22 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -17,7 +17,6 @@
 #include <linux/limits.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-#include <linux/interrupt.h>
 #include <linux/swab.h>
 #include <linux/io.h>
 
@@ -123,7 +122,7 @@ struct tpci200_regs {
 struct slot_irq {
 	struct ipack_device *holder;
 	int		vector;
-	int		(*handler)(void *);
+	irqreturn_t	(*handler)(void *);
 	void		*arg;
 };
 
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 4cc9173..8e61ebd 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -263,7 +263,7 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 	tty_kref_put(tty);
 }
 
-static int ipoctal_irq_handler(void *arg)
+static irqreturn_t ipoctal_irq_handler(void *arg)
 {
 	unsigned int i;
 	struct ipoctal *ipoctal = (struct ipoctal *) arg;
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 0ea9d84..9c3079d 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -11,6 +11,7 @@
 
 #include <linux/mod_devicetable.h>
 #include <linux/device.h>
+#include <linux/interrupt.h>
 
 #include "ipack_ids.h"
 
@@ -126,7 +127,8 @@ struct ipack_driver {
 struct ipack_bus_ops {
 	int (*map_space) (struct ipack_device *dev, unsigned int memory_size, int space);
 	int (*unmap_space) (struct ipack_device *dev, int space);
-	int (*request_irq) (struct ipack_device *dev, int vector, int (*handler)(void *), void *arg);
+	int (*request_irq) (struct ipack_device *dev, int vector,
+			    irqreturn_t (*handler)(void *), void *arg);
 	int (*free_irq) (struct ipack_device *dev);
 	int (*get_clockrate) (struct ipack_device *dev);
 	int (*set_clockrate) (struct ipack_device *dev, int mherz);
-- 
1.7.10.4

