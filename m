Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2DBOdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:33:44 -0400
Received: from 10.mo3.mail-out.ovh.net ([87.98.165.232]:48898 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751817Ab2DBOdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:33:43 -0400
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH 1/1] usb: Kconfig fix display
Date: Mon,  2 Apr 2012 13:13:50 +0200
Message-Id: <1333365230-15450-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
X-Ovh-Tracer-Id: 10201216106103417624
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegtddrtdefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhephffvufffkffosedttdertdertddt
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegfedrtdelucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhephffvufffkffosedttdertdertddt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move HAS option before menuconfig so the USB option will show in the sub menu
and not the drivers menu.
Introduce in commit 53c6bc24fdc8db87109a5760579cbb060fa644cf usb: Don't make
USB_ARCH_HAS_{XHCI,OHCI,EHCI} depend on USB_SUPPORT.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index cbd8f5f..76316a3 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -2,14 +2,6 @@
 # USB device configuration
 #
 
-menuconfig USB_SUPPORT
-	bool "USB support"
-	depends on HAS_IOMEM
-	default y
-	---help---
-	  This option adds core support for Universal Serial Bus (USB).
-	  You will also need drivers from the following menu to make use of it.
-
 # many non-PCI SOC chips embed OHCI
 config USB_ARCH_HAS_OHCI
 	boolean
@@ -63,6 +55,14 @@ config USB_ARCH_HAS_XHCI
 	boolean
 	default PCI
 
+menuconfig USB_SUPPORT
+	bool "USB support"
+	depends on HAS_IOMEM
+	default y
+	---help---
+	  This option adds core support for Universal Serial Bus (USB).
+	  You will also need drivers from the following menu to make use of it.
+
 if USB_SUPPORT
 
 config USB_COMMON
-- 
1.7.9.1

