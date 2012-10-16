Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2JPVye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:54:34 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:64552 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab2JPVyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:54:31 -0400
X-Greylist: delayed 3609 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 17:54:31 EDT
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Matthew Garrett <mjg@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 2/5] ACPI: Reorder IPMI driver before any other ACPI drivers
Date: Tue, 16 Oct 2012 15:53:37 -0500
Message-id: <1350420820-7156-3-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1350420820-7156-1-git-send-email-minyard@acm.org>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Drivers may make calls that require the ACPI IPMI driver to have been
initialised already, so make sure that it appears earlier in the build
order.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/acpi/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 47199e2..82422fe 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -47,6 +47,10 @@ acpi-y				+= video_detect.o
 endif
 
 # These are (potentially) separate modules
+
+# IPMI may be used by other drivers, so it has to initialise before them
+obj-$(CONFIG_ACPI_IPMI)		+= acpi_ipmi.o
+
 obj-$(CONFIG_ACPI_AC) 		+= ac.o
 obj-$(CONFIG_ACPI_BUTTON)	+= button.o
 obj-$(CONFIG_ACPI_FAN)		+= fan.o
@@ -70,6 +74,5 @@ processor-y			+= processor_idle.o processor_thermal.o
 processor-$(CONFIG_CPU_FREQ)	+= processor_perflib.o
 
 obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
-obj-$(CONFIG_ACPI_IPMI)		+= acpi_ipmi.o
 
 obj-$(CONFIG_ACPI_APEI)		+= apei/
-- 
1.7.4.1

