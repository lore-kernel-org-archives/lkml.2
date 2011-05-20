Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934964Ab1ETAMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:12:05 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45475 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934941Ab1ETAMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:02 -0400
X-Sasl-enc: hXtG9s7oVZdpPPhV7ecy/XgVQOTcmWEttEfnWvxVyXHQ 1305850321
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/44] Introduce CONFIG_GOOGLE_FIRMWARE
Date: Thu, 19 May 2011 17:10:50 -0700
Message-Id: <1305850262-9575-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

In order to keep Google's firmware drivers organized amongst themselves,
all Google firmware drivers are gated on CONFIG_GOOGLE_FIRMWARE=y, which
defaults to 'n' in the kernel build.

Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/Makefile       |    2 +-
 drivers/firmware/google/Kconfig |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index d7d6009..47338c9 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -14,4 +14,4 @@ obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
 obj-$(CONFIG_SIGMA)		+= sigma.o
 
-obj-y  += google/
+obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
index 640dc6b..87096b6 100644
--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -1,3 +1,15 @@
+config GOOGLE_FIRMWARE
+	bool "Google Firmware Drivers"
+	depends on X86
+	default n
+	help
+	  These firmware drivers are used by Google's servers.  They are
+	  only useful if you are working directly on one of their
+	  proprietary servers.  If in doubt, say "N".
+
+menu "Google Firmware Drivers"
+	depends on GOOGLE_FIRMWARE
+
 config GOOGLE_SMI
 	tristate "SMI interface for Google platforms"
 	depends on ACPI && DMI
@@ -15,3 +27,5 @@ config GOOGLE_MEMCONSOLE
 	  This option enables the kernel to search for a firmware log in
 	  the EBDA on Google servers.  If found, this log is exported to
 	  userland in the file /sys/firmware/log.
+
+endmenu
-- 
1.7.4.2

