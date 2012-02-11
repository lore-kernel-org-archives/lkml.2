Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab2BKTo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 14:44:57 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:52719 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2BKToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 14:44:21 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 03/13] firewire-sbp-target: Add Kconfig, Makefile and TODO
Date: Sat, 11 Feb 2012 19:44:02 +0000
Message-Id: <1328989452-20921-4-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328989452-20921-1-git-send-email-bootc@bootc.net>
References: <4E4BD560.4010806@bootc.net>
 <1328989452-20921-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FireWire SBP-2 Target is a driver for using an IEEE-1394 connection
as a SCSI transport. This module uses the SCSI Target framework to
expose LUNs to other machines attached to a FireWire bus, in effect
acting as a FireWire hard disk similar to FireWire Target Disk mode on
older Apple computers.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/target/sbp/Kconfig  |   14 ++++++++++++++
 drivers/target/sbp/Makefile |   13 +++++++++++++
 drivers/target/sbp/TODO     |    7 +++++++
 3 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/sbp/Kconfig
 create mode 100644 drivers/target/sbp/Makefile
 create mode 100644 drivers/target/sbp/TODO

diff --git a/drivers/target/sbp/Kconfig b/drivers/target/sbp/Kconfig
new file mode 100644
index 0000000..8544010
--- /dev/null
+++ b/drivers/target/sbp/Kconfig
@@ -0,0 +1,14 @@
+
+config FIREWIRE_SBP_TARGET
+	tristate "FireWire SBP-2 fabric module"
+	depends on TARGET_CORE && CONFIGFS_FS && FIREWIRE && EXPERIMENTAL
+	default n
+	help
+	  Say Y or M here to enable SCSI target functionality over FireWire.
+	  This enables you to expose SCSI devices to other nodes on the FireWire
+	  bus, for example hard disks. Similar to FireWire Target Disk mode on
+	  older Apple computers.
+
+	  To compile this driver as a module, say M here: The module will be
+	  called firewire-sbp-target.
+
diff --git a/drivers/target/sbp/Makefile b/drivers/target/sbp/Makefile
new file mode 100644
index 0000000..3a3e155
--- /dev/null
+++ b/drivers/target/sbp/Makefile
@@ -0,0 +1,13 @@
+
+firewire-sbp-target-y += \
+	sbp_configfs.o \
+	sbp_fabric.o \
+	sbp_login.o \
+	sbp_management_agent.o \
+	sbp_proto.o \
+	sbp_scsi_cmnd.o \
+	sbp_target_agent.o \
+	sbp_util.o
+
+obj-$(CONFIG_FIREWIRE_SBP_TARGET) += firewire-sbp-target.o
+
diff --git a/drivers/target/sbp/TODO b/drivers/target/sbp/TODO
new file mode 100644
index 0000000..eaec1c9
--- /dev/null
+++ b/drivers/target/sbp/TODO
@@ -0,0 +1,7 @@
+* Force-terminate sessions when disabling targets
+* Ability to have several SCSI commands in-flight (TCQ?)
+* Retry failed FireWire transactions a few times with exponential backoff
+* Take into account the page_size field for transfers and/or page tables
+* Handle descriptor format sense data
+* Implement QUERY LOGINS management ORB
+* Implement TASK MANAGEMENT functionality
-- 
1.7.9

