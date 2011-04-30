Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121Ab1D3Ajx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:39:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26676 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761048Ab1D3Ajv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:39:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qan1eBRMU45mnBUlA8orPd+lNbvYWphM5sxfgrFhbp7eWnBmrSChnOa6MVcKUa+ls
	JTXhZV63KzbRSHN2Aw9kA==
Subject: [PATCH v5 3/3] Introduce CONFIG_GOOGLE_FIRMWARE
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Fri, 29 Apr 2011 17:39:31 -0700
Message-ID: <20110430003930.11515.47486.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110429234028.GA28476@kroah.com>
References: <20110429234028.GA28476@kroah.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to keep Google's firmware drivers organized amongst themselves,
all Google firmware drivers are gated on CONFIG_GOOGLE_FIRMWARE=y, which
defaults to 'n' in the kernel build.

Signed-off-by: Mike Waychison <mikew@google.com>

---
Changelog:
v5:
   - refreshed to next-20110429
v4:
   - Moved to end of series.
v3:
   - Removed comment about 'other implementations' in Kconfig message as
     per gregkh.
---
 drivers/firmware/Makefile       |    2 +-
 drivers/firmware/google/Kconfig |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index d7d6009..47338c9791 100644
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

