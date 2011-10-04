Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab1JDTri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:47:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135Ab1JDTrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:47:37 -0400
Date: Tue, 4 Oct 2011 12:34:14 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Move hyperv out of the drivers/staging/ directory
Message-ID: <20111004193414.GA15672@suse.de>
References: <1316708240-25048-1-git-send-email-kys@microsoft.com>
 <20110922170450.GA4490@suse.de>
 <6E21E5352C11B742B20C142EB499E048081E935D@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110922173618.GA5624@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004170415.GA1320@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

KY, how about the following patch?

Any objection from the virt developers about this?

KY, I'd like to get your signed-off-by before committing this, care to
test this out and pass it around the other hyperv developers and then
sign off on it?  Then I will be glad to commit this to my tree.

thanks,

greg k-h



--fdj2RfSjLxBAspz7
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Staging-hv-move-hyperv-code-out-of-staging-directory.patch"

>From 82a986ecb50f336751dc18370a0ec61f2d3002db Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@suse.de>
Date: Tue, 4 Oct 2011 12:29:52 -0700
Subject: Staging: hv: move hyperv code out of staging directory

After many years wandering the desert, it is finally time for the
Microsoft HyperV code to move out of the staging directory.  Or at least
the core hyperv bus code, and the utility driver, the rest still have
some review to get through by the various subsystem maintainers.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/hv/Kconfig                                 |   14 ++++++++++
 drivers/hv/Makefile                                |    7 +++++
 drivers/{staging => }/hv/channel.c                 |    2 +-
 drivers/{staging => }/hv/channel_mgmt.c            |    2 +-
 drivers/{staging => }/hv/connection.c              |    2 +-
 drivers/{staging => }/hv/hv.c                      |    2 +-
 drivers/{staging => }/hv/hv_kvp.c                  |    2 +-
 drivers/{staging => }/hv/hv_kvp.h                  |    0
 drivers/{staging => }/hv/hv_util.c                 |    2 +-
 drivers/{staging => }/hv/hyperv_vmbus.h            |    3 +-
 drivers/{staging => }/hv/ring_buffer.c             |    2 +-
 drivers/{staging => }/hv/vmbus_drv.c               |    2 +-
 drivers/staging/hv/Kconfig                         |   28 ++-----------------
 drivers/staging/hv/Makefile                        |    7 +----
 drivers/staging/hv/hv_mouse.c                      |    3 +-
 drivers/staging/hv/hyperv_net.h                    |    2 +-
 drivers/staging/hv/storvsc_drv.c                   |    2 +-
 {drivers/staging/hv => include/linux}/hyperv.h     |    0
 .../staging/hv/tools => tools/hv}/hv_kvp_daemon.c  |    0
 21 files changed, 41 insertions(+), 45 deletions(-)
 create mode 100644 drivers/hv/Kconfig
 create mode 100644 drivers/hv/Makefile
 rename drivers/{staging => }/hv/channel.c (99%)
 rename drivers/{staging => }/hv/channel_mgmt.c (99%)
 rename drivers/{staging => }/hv/connection.c (99%)
 rename drivers/{staging => }/hv/hv.c (99%)
 rename drivers/{staging => }/hv/hv_kvp.c (99%)
 rename drivers/{staging => }/hv/hv_kvp.h (100%)
 rename drivers/{staging => }/hv/hv_util.c (99%)
 rename drivers/{staging => }/hv/hyperv_vmbus.h (99%)
 rename drivers/{staging => }/hv/ring_buffer.c (99%)
 rename drivers/{staging => }/hv/vmbus_drv.c (99%)
 rename {drivers/staging/hv => include/linux}/hyperv.h (100%)
 rename {drivers/staging/hv/tools => tools/hv}/hv_kvp_daemon.c (100%)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 95b9e7e..ce3c35f 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -130,4 +130,6 @@ source "drivers/iommu/Kconfig"
 
 source "drivers/virt/Kconfig"
 
+source "drivers/hv/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 7fa433a..ef693cf 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -127,3 +127,5 @@ obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
 
 # Virtualization drivers
 obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
+obj-$(CONFIG_HYPERV)		+= hv/
+
diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
new file mode 100644
index 0000000..9fa09ac
--- /dev/null
+++ b/drivers/hv/Kconfig
@@ -0,0 +1,14 @@
+config HYPERV
+	tristate "Microsoft Hyper-V client drivers"
+	depends on X86 && ACPI && PCI
+	help
+	  Select this option to run Linux as a Hyper-V client operating
+	  system.
+
+config HYPERV_UTILS
+	tristate "Microsoft Hyper-V Utilities driver"
+	depends on HYPERV && CONNECTOR && NLS
+	help
+	  Select this option to enable the Hyper-V Utilities.
+
+
diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
new file mode 100644
index 0000000..a23938b
--- /dev/null
+++ b/drivers/hv/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_HYPERV)		+= hv_vmbus.o
+obj-$(CONFIG_HYPERV_UTILS)	+= hv_utils.o
+
+hv_vmbus-y := vmbus_drv.o \
+		 hv.o connection.o channel.o \
+		 channel_mgmt.o ring_buffer.o
+hv_utils-y := hv_util.o hv_kvp.o
diff --git a/drivers/staging/hv/channel.c b/drivers/hv/channel.c
similarity index 99%
rename from drivers/staging/hv/channel.c
rename to drivers/hv/channel.c
index b6f3d38..4065374 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -26,8 +26,8 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/hyperv.h>
 
-#include "hyperv.h"
 #include "hyperv_vmbus.h"
 
 #define NUM_PAGES_SPANNED(addr, len) \
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
similarity index 99%
rename from drivers/staging/hv/channel_mgmt.c
rename to drivers/hv/channel_mgmt.c
index 9f00752..41bf287 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -28,8 +28,8 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/completion.h>
+#include <linux/hyperv.h>
 
-#include "hyperv.h"
 #include "hyperv_vmbus.h"
 
 struct vmbus_channel_message_table_entry {
diff --git a/drivers/staging/hv/connection.c b/drivers/hv/connection.c
similarity index 99%
rename from drivers/staging/hv/connection.c
rename to drivers/hv/connection.c
index 649b91b..5f438b6 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -29,8 +29,8 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/hyperv.h>
 
-#include "hyperv.h"
 #include "hyperv_vmbus.h"
 
 
diff --git a/drivers/staging/hv/hv.c b/drivers/hv/hv.c
similarity index 99%
rename from drivers/staging/hv/hv.c
rename to drivers/hv/hv.c
index 06f1e15..931b7b0 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -25,8 +25,8 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/hyperv.h>
 
-#include "hyperv.h"
 #include "hyperv_vmbus.h"
 
 /* The one and only */
diff --git a/drivers/staging/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
similarity index 99%
rename from drivers/staging/hv/hv_kvp.c
rename to drivers/hv/hv_kvp.c
index 9aa9ede..219124b 100644
--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -26,8 +26,8 @@
 #include <linux/nls.h>
 #include <linux/connector.h>
 #include <linux/workqueue.h>
+#include <linux/hyperv.h>
 
-#include "hyperv.h"
 #include "hv_kvp.h"
 
 
diff --git a/drivers/staging/hv/hv_kvp.h b/drivers/hv/hv_kvp.h
similarity index 100%
rename from drivers/staging/hv/hv_kvp.h
rename to drivers/hv/hv_kvp.h
diff --git a/drivers/staging/hv/hv_util.c b/drivers/hv/hv_util.c
similarity index 99%
rename from drivers/staging/hv/hv_util.c
rename to drivers/hv/hv_util.c
index faa6607..e0e3a6d 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -26,8 +26,8 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/reboot.h>
+#include <linux/hyperv.h>
 
-#include "hyperv.h"
 #include "hv_kvp.h"
 
 
diff --git a/drivers/staging/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
similarity index 99%
rename from drivers/staging/hv/hyperv_vmbus.h
rename to drivers/hv/hyperv_vmbus.h
index 3d2d836..8261cb6 100644
--- a/drivers/staging/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -28,8 +28,7 @@
 #include <linux/list.h>
 #include <asm/sync_bitops.h>
 #include <linux/atomic.h>
-
-#include "hyperv.h"
+#include <linux/hyperv.h>
 
 /*
  * The below CPUID leaves are present if VersionAndFeatures.HypervisorPresent
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
similarity index 99%
rename from drivers/staging/hv/ring_buffer.c
rename to drivers/hv/ring_buffer.c
index 70e2e66..f594ed0 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -25,8 +25,8 @@
 
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/hyperv.h>
 
-#include "hyperv.h"
 #include "hyperv_vmbus.h"
 
 
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
similarity index 99%
rename from drivers/staging/hv/vmbus_drv.c
rename to drivers/hv/vmbus_drv.c
index d2562af..b0d08f9 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -32,8 +32,8 @@
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <linux/completion.h>
+#include <linux/hyperv.h>
 
-#include "hyperv.h"
 #include "hyperv_vmbus.h"
 
 
diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
index 815f8c2..072185e 100644
--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@ -1,39 +1,17 @@
-config HYPERV
-	tristate "Microsoft Hyper-V client drivers"
-	depends on X86 && ACPI && PCI
-	default n
-	help
-	  Select this option to run Linux as a Hyper-V client operating
-	  system.
-
-if HYPERV
-
 config HYPERV_STORAGE
 	tristate "Microsoft Hyper-V virtual storage driver"
-	depends on SCSI
-	default HYPERV
+	depends on HYPERV && SCSI
 	help
 	 Select this option to enable the Hyper-V virtual storage driver.
 
 config HYPERV_NET
 	tristate "Microsoft Hyper-V virtual network driver"
-	depends on NET
-	default HYPERV
+	depends on HYPERV && NET
 	help
 	  Select this option to enable the Hyper-V virtual network driver.
 
-config HYPERV_UTILS
-	tristate "Microsoft Hyper-V Utilities driver"
-	depends on CONNECTOR && NLS
-	default HYPERV
-	help
-	  Select this option to enable the Hyper-V Utilities.
-
 config HYPERV_MOUSE
 	tristate "Microsoft Hyper-V mouse driver"
-	depends on HID
-	default HYPERV
+	depends on HYPERV && HID
 	help
 	  Select this option to enable the Hyper-V mouse driver.
-
-endif
diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
index bd176b1..e071c12 100644
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@ -1,12 +1,7 @@
-obj-$(CONFIG_HYPERV)		+= hv_vmbus.o hv_timesource.o
+obj-$(CONFIG_HYPERV)		+= hv_timesource.o
 obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
 obj-$(CONFIG_HYPERV_NET)	+= hv_netvsc.o
-obj-$(CONFIG_HYPERV_UTILS)	+= hv_utils.o
 obj-$(CONFIG_HYPERV_MOUSE)	+= hv_mouse.o
 
-hv_vmbus-y := vmbus_drv.o \
-		 hv.o connection.o channel.o \
-		 channel_mgmt.o ring_buffer.o
 hv_storvsc-y := storvsc_drv.o
 hv_netvsc-y := netvsc_drv.o netvsc.o rndis_filter.o
-hv_utils-y := hv_util.o hv_kvp.o
diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index edbb479..c354ade 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -22,8 +22,7 @@
 #include <linux/input.h>
 #include <linux/hid.h>
 #include <linux/hiddev.h>
-
-#include "hyperv.h"
+#include <linux/hyperv.h>
 
 
 struct hv_input_dev_info {
diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index 366dd2b..ac1ec84 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -26,7 +26,7 @@
 #define _HYPERV_NET_H
 
 #include <linux/list.h>
-#include "hyperv.h"
+#include <linux/hyperv.h>
 
 /* Fwd declaration */
 struct hv_netvsc_packet;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 807c94d..c4dfed4 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/hyperv.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -40,7 +41,6 @@
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_dbg.h>
 
-#include "hyperv.h"
 
 #define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
 static int storvsc_ringbuffer_size = STORVSC_RING_BUFFER_SIZE;
diff --git a/drivers/staging/hv/hyperv.h b/include/linux/hyperv.h
similarity index 100%
rename from drivers/staging/hv/hyperv.h
rename to include/linux/hyperv.h
diff --git a/drivers/staging/hv/tools/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
similarity index 100%
rename from drivers/staging/hv/tools/hv_kvp_daemon.c
rename to tools/hv/hv_kvp_daemon.c
-- 
1.7.6.4


--fdj2RfSjLxBAspz7--
