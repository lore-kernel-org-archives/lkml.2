Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030Ab1D2W4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:56:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40676 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1D2W4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:56:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=vKPu76Exl5oYaLopN6Q8ZdONPF8Vxzpe66BXzRNrnWNBDl8JQ0D/1zMr/iISJm6FP
	Q22kVDEVydmTc4RLOe8HA==
Subject: [PATCH v4 3/3] Introduce CONFIG_GOOGLE_FIRMWARE
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Fri, 29 Apr 2011 15:56:02 -0700
Message-ID: <20110429225601.22013.92629.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110429212328.GA19207@kroah.com>
References: <20110429212328.GA19207@kroah.com>
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
index 9fcf3b2..5a7e273 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -13,4 +13,4 @@ obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
 
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

