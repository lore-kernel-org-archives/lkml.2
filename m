Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1GORek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:34:40 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37379
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754242Ab1GORaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 098/117] Staging: hv: storvsc: Handle IDE devices using the storvsc driver
Date: Fri, 15 Jul 2011 10:47:26 -0700
Message-Id: <1310752065-27895-98-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, enable handling of all IDE devices by extending the storvsc
device id table to handle IDE guid. As part of this cleanup Kconfig
and Hyper-V Makefile to not build the IDE driver (blkvsc).

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/Kconfig       |    7 -------
 drivers/staging/hv/Makefile      |    2 --
 drivers/staging/hv/storvsc_drv.c |    7 +++++++
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
index 5e0c9f6..26b5064 100644
--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@ -15,13 +15,6 @@ config HYPERV_STORAGE
 	help
 	 Select this option to enable the Hyper-V virtual storage driver.
 
-config HYPERV_BLOCK
-	tristate "Microsoft Hyper-V virtual block driver"
-	depends on BLOCK && SCSI && (LBDAF || 64BIT)
-	default HYPERV
-	help
-	  Select this option to enable the Hyper-V virtual block driver.
-
 config HYPERV_NET
 	tristate "Microsoft Hyper-V virtual network driver"
 	depends on NET
diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
index 3004674..bb89437 100644
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@ -1,6 +1,5 @@
 obj-$(CONFIG_HYPERV)		+= hv_vmbus.o hv_timesource.o
 obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
-obj-$(CONFIG_HYPERV_BLOCK)	+= hv_blkvsc.o
 obj-$(CONFIG_HYPERV_NET)	+= hv_netvsc.o
 obj-$(CONFIG_HYPERV_UTILS)	+= hv_utils.o
 obj-$(CONFIG_HYPERV_MOUSE)	+= hv_mouse.o
@@ -9,6 +8,5 @@ hv_vmbus-y := vmbus_drv.o \
 		 hv.o connection.o channel.o \
 		 channel_mgmt.o ring_buffer.o
 hv_storvsc-y := storvsc_drv.o storvsc.o
-hv_blkvsc-y := blkvsc_drv.o  storvsc.o
 hv_netvsc-y := netvsc_drv.o netvsc.o rndis_filter.o
 hv_utils-y := hv_util.o hv_kvp.o
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index efbc603..5777482 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -657,6 +657,13 @@ static const struct hv_vmbus_device_id id_table[] = {
 		}
 	},
 	{
+		/* IDE guid */
+		.guid = {
+			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
+			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
+		}
+	},
+	{
 		.guid = {
 			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
-- 
1.7.4.1

