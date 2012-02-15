Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532Ab2BOBPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:15:51 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52385 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761445Ab2BOBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:45 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 14/14] Add Kconfig and Makefiles for VMCI
Date: Tue, 14 Feb 2012 17:05:55 -0800
Message-Id: <1329267955-32367-15-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/Kconfig           |    1 +
 drivers/misc/Makefile          |    1 +
 drivers/misc/vmw_vmci/Kconfig  |   16 ++++++++++++++++
 drivers/misc/vmw_vmci/Makefile |   36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/Kconfig
 create mode 100644 drivers/misc/vmw_vmci/Makefile

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 5664696..b761cc5 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -508,5 +508,6 @@ source "drivers/misc/ti-st/Kconfig"
 source "drivers/misc/lis3lv02d/Kconfig"
 source "drivers/misc/carma/Kconfig"
 source "drivers/misc/altera-stapl/Kconfig"
+source "drivers/misc/vmw_vmci/Kconfig"
 
 endif # MISC_DEVICES
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index b26495a..5aba5b5 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -48,3 +48,4 @@ obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
+obj-$(CONFIG_VMW_VMCI)		+= vmw_vmci/
diff --git a/drivers/misc/vmw_vmci/Kconfig b/drivers/misc/vmw_vmci/Kconfig
new file mode 100644
index 0000000..55015e7
--- /dev/null
+++ b/drivers/misc/vmw_vmci/Kconfig
@@ -0,0 +1,16 @@
+#
+# VMware VMCI device
+#
+
+config VMWARE_VMCI
+	tristate "VMware VMCI Driver"
+	depends on X86
+	help
+	  This is VMware's Virtual Machine Communication Interface.  It enables
+	  high-speed communication between host and guest in a virtual
+	  environment via the VMCI virtual device.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vmw_vmci.
diff --git a/drivers/misc/vmw_vmci/Makefile b/drivers/misc/vmw_vmci/Makefile
new file mode 100644
index 0000000..899e565
--- /dev/null
+++ b/drivers/misc/vmw_vmci/Makefile
@@ -0,0 +1,36 @@
+################################################################################
+#
+# Linux driver for VMware's VMCI device.
+#
+# Copyright (C) 2007-2012, VMware, Inc. All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
+# Free Software Foundation; version 2 of the License and no later version.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+# NON INFRINGEMENT.  See the GNU General Public License for more
+# details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+#
+# The full GNU General Public License is included in this distribution in
+# the file called "COPYING".
+#
+# Maintained by: Andrew Stiegmann <pv-drivers@vmware.com>
+#
+################################################################################
+
+#
+# Makefile for the VMware VMCI
+#
+
+obj-$(CONFIG_VMWARE_VMCI) += vmci.o
+
+vmci-objs := driver.o vmciContext.o vmciDatagram.o vmciDriver.o vmciDoorbell.o
+vmci-objs += vmciEvent.o vmciHashtable.o vmciKernelIf.o vmciQPair.o
+vmci-objs += vmciQueuePair.o vmciResource.o vmciRoute.o
-- 
1.7.0.4

