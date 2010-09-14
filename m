Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0INPCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:02:54 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56589 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab0INPCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:02:47 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH v2 01/10] RapidIO: Fix RapidIO sysfs hierarchy
Date: Tue, 14 Sep 2010 10:59:14 -0400
Message-Id: <1284476363-1677-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make RapidIO devices appear in /sys/devices/rapidio directory instead of top
of /sys/devices directory.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/rio-driver.c |    2 +-
 drivers/rapidio/rio-scan.c   |    1 +
 include/linux/rio.h          |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
index 3222fa3..0f4a53b 100644
--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -192,7 +192,7 @@ static int rio_match_bus(struct device *dev, struct device_driver *drv)
       out:return 0;
 }
 
-static struct device rio_bus = {
+struct device rio_bus = {
 	.init_name = "rapidio",
 };
 
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 8070e07..1123be8 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -478,6 +478,7 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 	}
 
 	rdev->dev.bus = &rio_bus_type;
+	rdev->dev.parent = &rio_bus;
 
 	device_initialize(&rdev->dev);
 	rdev->dev.release = rio_release_dev;
diff --git a/include/linux/rio.h b/include/linux/rio.h
index bd6eb0e..84c9f8c 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -67,6 +67,7 @@
 #define RIO_PW_MSG_SIZE		64
 
 extern struct bus_type rio_bus_type;
+extern struct device rio_bus;
 extern struct list_head rio_devices;	/* list of all devices */
 
 struct rio_mport;
-- 
1.7.0.5

