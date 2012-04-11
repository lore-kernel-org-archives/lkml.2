Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399Ab2DKOV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:21:27 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:54911 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760374Ab2DKOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:21:23 -0400
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 03/11] firewire-sbp-target: Add Kconfig, Makefile and TODO
Date: Wed, 11 Apr 2012 15:20:35 +0100
Message-Id: <1334154043-69076-4-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334154043-69076-1-git-send-email-bootc@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
 <1334154043-69076-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FireWire SBP-2 Target is a driver for using an IEEE-1394 connection
as a SCSI transport. This module uses the SCSI Target framework to
expose LUNs to other machines attached to a FireWire bus, in effect
acting as a FireWire hard disk similar to FireWire Target Disk mode on
many Apple computers.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/target/sbp/Kconfig  |   13 +++++++++++++
 drivers/target/sbp/Makefile |   11 +++++++++++
 drivers/target/sbp/TODO     |    7 +++++++
 3 files changed, 31 insertions(+)
 create mode 100644 drivers/target/sbp/Kconfig
 create mode 100644 drivers/target/sbp/Makefile
 create mode 100644 drivers/target/sbp/TODO

diff --git a/drivers/target/sbp/Kconfig b/drivers/target/sbp/Kconfig
new file mode 100644
index 0000000..c9f85e9
--- /dev/null
+++ b/drivers/target/sbp/Kconfig
@@ -0,0 +1,13 @@
+
+config FIREWIRE_SBP_TARGET
+	tristate "FireWire SBP-2 fabric module"
+	depends on FIREWIRE && EXPERIMENTAL
+	help
+	  Say Y or M here to enable SCSI target functionality over FireWire.
+	  This enables you to expose SCSI devices to other nodes on the FireWire
+	  bus, for example hard disks. Similar to FireWire Target Disk mode on
+	  many Apple computers.
+
+	  To compile this driver as a module, say M here: The module will be
+	  called firewire-sbp-target.
+
diff --git a/drivers/target/sbp/Makefile b/drivers/target/sbp/Makefile
new file mode 100644
index 0000000..c8f73f4
--- /dev/null
+++ b/drivers/target/sbp/Makefile
@@ -0,0 +1,11 @@
+
+firewire-sbp-target-y += \
+	sbp_configfs.o \
+	sbp_fabric.o \
+	sbp_login.o \
+	sbp_management_agent.o \
+	sbp_scsi_cmnd.o \
+	sbp_target_agent.o
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
1.7.9.5

