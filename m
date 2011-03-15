Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1COG7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 02:59:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab1COG7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 02:59:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=caWagdju/tudQEWwd86HWgtxlULt4bDlbF6EOExA4q8gQqWMToYhxgpSOYtjltjBk
	P9FcEmuAszLOfTAuqKO1w==
Subject: [PATCH v3 3/5] Introduce CONFIG_GOOGLE_FIRMWARE
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Mon, 14 Mar 2011 23:58:55 -0700
Message-ID: <20110315065855.12047.31930.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110315065839.12047.70666.stgit@mike.mtv.corp.google.com>
References: <20110315065839.12047.70666.stgit@mike.mtv.corp.google.com>
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
Changelog:
v3:
   - Removed comment about 'other implementations' in Kconfig message as
     per gregkh.
---
 drivers/firmware/Kconfig         |    2 ++
 drivers/firmware/Makefile        |    2 ++
 drivers/firmware/google/Kconfig  |   13 +++++++++++++
 drivers/firmware/google/Makefile |    1 +
 4 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firmware/google/Kconfig
 create mode 100644 drivers/firmware/google/Makefile

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 3c56afc..9b00072 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -145,4 +145,6 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
 
+source "drivers/firmware/google/Kconfig"
+
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 20c17fc..5a7e273 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -12,3 +12,5 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
+
+obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
new file mode 100644
index 0000000..02a7366
--- /dev/null
+++ b/drivers/firmware/google/Kconfig
@@ -0,0 +1,13 @@
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
+endmenu
diff --git a/drivers/firmware/google/Makefile b/drivers/firmware/google/Makefile
new file mode 100644
index 0000000..8b13789
--- /dev/null
+++ b/drivers/firmware/google/Makefile
@@ -0,0 +1 @@
+

