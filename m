Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1AYAY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:24:58 -0500
Received: from smtp-out.google.com ([74.125.121.67]:59867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1AYAYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:24:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=WKxqOfL1tK5ikbp+bDxXmYZ0SiLqPFRTzRbEL1vgxrC0hV6u6hXUAVXfv+ZfFCpgr
	AfcLgE1d4u4OQ0t55nCPg==
Subject: [PATCH v1 2/6] Introduce CONFIG_GOOGLE_FIRMWARE
To: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org
From: Mike Waychison <mikew@google.com>
Cc: San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Date: Mon, 24 Jan 2011 16:24:44 -0800
Message-ID: <20110125002444.12637.63905.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to keep Google's firmware drivers organized amongst themselves,
create a new directory for them to live in.  As well, all Google
firmware drivers are gated on CONFIG_GOOGLE_FIRMWARE=y, which defaults
to 'n' in the kernel build.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/Kconfig         |    2 ++
 drivers/firmware/Makefile        |    2 ++
 drivers/firmware/google/Kconfig  |   14 ++++++++++++++
 drivers/firmware/google/Makefile |    1 +
 4 files changed, 19 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firmware/google/Kconfig
 create mode 100644 drivers/firmware/google/Makefile

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index e710424..d848b26 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -134,4 +134,6 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
 
+source "drivers/firmware/google/Kconfig"
+
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 1c3c173..6f68007 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -11,3 +11,5 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
+
+obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
new file mode 100644
index 0000000..7834729
--- /dev/null
+++ b/drivers/firmware/google/Kconfig
@@ -0,0 +1,14 @@
+config GOOGLE_FIRMWARE
+	bool "Google Firmware Drivers"
+	depends on X86
+	default n
+	help
+	  These firmware drivers are used by Google's servers.  They are
+	  only useful if you are working directly on one of their
+	  proprietary servers or implementing similar firmware
+	  interfaces.  If in doubt, say "N".
+
+menu "Google Firmware Drivers"
+	depends on GOOGLE_FIRMWARE
+
+endmenu
diff --git a/drivers/firmware/google/Makefile b/drivers/firmware/google/Makefile
new file mode 100644
index 0000000..8b13789
--- /dev/null
+++ b/drivers/firmware/google/Makefile
@@ -0,0 +1 @@
+

