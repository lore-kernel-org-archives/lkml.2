Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2JPVyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:54:21 -0400
Received: from vms173021pub.verizon.net ([206.46.173.21]:44581 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2JPVyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:54:19 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 17:54:19 EDT
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Matthew Garrett <mjg@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 3/5] IPMI: Change link order
Date: Tue, 16 Oct 2012 15:53:38 -0500
Message-id: <1350420820-7156-4-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1350420820-7156-1-git-send-email-minyard@acm.org>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

IPMI must be initialised before ACPI in order to ensure that any IPMI
services are available before ACPI driver initialisation attempts to use
any IPMI operation regions.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/Makefile      |    4 ++++
 drivers/char/Makefile |    1 -
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 03da5b6..a16a8d0 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -17,6 +17,10 @@ obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
 obj-y				+= video/
 obj-y				+= idle/
+
+# IPMI must come before ACPI in order to provide IPMI opregion support
+obj-$(CONFIG_IPMI_HANDLER)	+= char/ipmi/
+
 obj-$(CONFIG_ACPI)		+= acpi/
 obj-$(CONFIG_SFI)		+= sfi/
 # PnP must come after ACPI since it will eventually need to check if acpi
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index d0b27a3..7ff1d0d 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -52,7 +52,6 @@ obj-$(CONFIG_TELCLOCK)		+= tlclk.o
 obj-$(CONFIG_MWAVE)		+= mwave/
 obj-$(CONFIG_AGP)		+= agp/
 obj-$(CONFIG_PCMCIA)		+= pcmcia/
-obj-$(CONFIG_IPMI_HANDLER)	+= ipmi/
 
 obj-$(CONFIG_HANGCHECK_TIMER)	+= hangcheck-timer.o
 obj-$(CONFIG_TCG_TPM)		+= tpm/
-- 
1.7.4.1

