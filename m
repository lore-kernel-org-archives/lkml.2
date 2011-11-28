Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1K1Vof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:44:35 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:45327
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752048Ab1K1Voe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:44:34 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 16:44:34 EST
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, kys@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Cc: Mike Sterling <Mike.Sterling@microsoft.com>,
        NetDev <netdev@vger.kernel.org>
Subject: [PATCH] staging: hv: move hv_netvsc out of staging area
Date: Mon, 28 Nov 2011 13:35:35 -0800
Message-Id: <1322516135-22221-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hv_netvsc has been reviewed on netdev mailing list on 6/09/2011.
All recommended changes have been made. We are requesting to move
it out of staging area.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: KY Srinivasan <kys@microsoft.com>
Signed-off-by: Mike Sterling <Mike.Sterling@microsoft.com>
Cc: NetDev <netdev@vger.kernel.org>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
---
 drivers/net/Kconfig                               |    2 ++
 drivers/net/Makefile                              |    2 ++
 drivers/net/hyperv/Kconfig                        |    5 +++++
 drivers/net/hyperv/Makefile                       |    3 +++
 drivers/{staging/hv => net/hyperv}/hyperv_net.h   |    0
 drivers/{staging/hv => net/hyperv}/netvsc.c       |    0
 drivers/{staging/hv => net/hyperv}/netvsc_drv.c   |    0
 drivers/{staging/hv => net/hyperv}/rndis_filter.c |    0
 drivers/staging/hv/Kconfig                        |    6 ------
 drivers/staging/hv/Makefile                       |    2 --
 drivers/staging/hv/TODO                           |    1 -
 11 files changed, 12 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/hyperv/Kconfig
 create mode 100644 drivers/net/hyperv/Makefile
 rename drivers/{staging/hv => net/hyperv}/hyperv_net.h (100%)
 rename drivers/{staging/hv => net/hyperv}/netvsc.c (100%)
 rename drivers/{staging/hv => net/hyperv}/netvsc_drv.c (100%)
 rename drivers/{staging/hv => net/hyperv}/rndis_filter.c (100%)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 654a5e9..99aa7fa 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -338,4 +338,6 @@ config VMXNET3
 	  To compile this driver as a module, choose M here: the
 	  module will be called vmxnet3.
 
+source "drivers/net/hyperv/Kconfig"
+
 endif # NETDEVICES
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index fa877cd..a81192b 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -66,3 +66,5 @@ obj-$(CONFIG_USB_USBNET)        += usb/
 obj-$(CONFIG_USB_ZD1201)        += usb/
 obj-$(CONFIG_USB_IPHETH)        += usb/
 obj-$(CONFIG_USB_CDC_PHONET)   += usb/
+
+obj-$(CONFIG_HYPERV_NET) += hyperv/
diff --git a/drivers/net/hyperv/Kconfig b/drivers/net/hyperv/Kconfig
new file mode 100644
index 0000000..936968d
--- /dev/null
+++ b/drivers/net/hyperv/Kconfig
@@ -0,0 +1,5 @@
+config HYPERV_NET
+	tristate "Microsoft Hyper-V virtual network driver"
+	depends on HYPERV
+	help
+	  Select this option to enable the Hyper-V virtual network driver.
diff --git a/drivers/net/hyperv/Makefile b/drivers/net/hyperv/Makefile
new file mode 100644
index 0000000..c8a6682
--- /dev/null
+++ b/drivers/net/hyperv/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_HYPERV_NET) += hv_netvsc.o
+
+hv_netvsc-y := netvsc_drv.o netvsc.o rndis_filter.o
diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
similarity index 100%
rename from drivers/staging/hv/hyperv_net.h
rename to drivers/net/hyperv/hyperv_net.h
diff --git a/drivers/staging/hv/netvsc.c b/drivers/net/hyperv/netvsc.c
similarity index 100%
rename from drivers/staging/hv/netvsc.c
rename to drivers/net/hyperv/netvsc.c
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
similarity index 100%
rename from drivers/staging/hv/netvsc_drv.c
rename to drivers/net/hyperv/netvsc_drv.c
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
similarity index 100%
rename from drivers/staging/hv/rndis_filter.c
rename to drivers/net/hyperv/rndis_filter.c
diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
index 072185e..8a51166 100644
--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@ -4,12 +4,6 @@ config HYPERV_STORAGE
 	help
 	 Select this option to enable the Hyper-V virtual storage driver.
 
-config HYPERV_NET
-	tristate "Microsoft Hyper-V virtual network driver"
-	depends on HYPERV && NET
-	help
-	  Select this option to enable the Hyper-V virtual network driver.
-
 config HYPERV_MOUSE
 	tristate "Microsoft Hyper-V mouse driver"
 	depends on HYPERV && HID
diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
index 0f55cee..6c97747 100644
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@ -1,6 +1,4 @@
 obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
-obj-$(CONFIG_HYPERV_NET)	+= hv_netvsc.o
 obj-$(CONFIG_HYPERV_MOUSE)	+= hv_mouse.o
 
 hv_storvsc-y := storvsc_drv.o
-hv_netvsc-y := netvsc_drv.o netvsc.o rndis_filter.o
diff --git a/drivers/staging/hv/TODO b/drivers/staging/hv/TODO
index ed4d636..fd080cb 100644
--- a/drivers/staging/hv/TODO
+++ b/drivers/staging/hv/TODO
@@ -1,5 +1,4 @@
 TODO:
-	- audit the network driver
 	- audit the scsi driver
 
 Please send patches for this code to Greg Kroah-Hartman <gregkh@suse.de>,
-- 
1.7.4.1

