Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2IXPGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:06:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2IXPGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:06:12 -0400
From: Matthew Garrett <mjg@redhat.com>
To: yakui.zhao@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cminyard@mvista.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/4] ACPI: Reorder IPMI driver before any other ACPI drivers
Date: Mon, 24 Sep 2012 11:05:37 -0400
Message-Id: <1348499140-13550-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1348499140-13550-1-git-send-email-mjg@redhat.com>
References: <1348499140-13550-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers may make calls that require the ACPI IPMI driver to have been
initialised already, so make sure that it appears earlier in the build
order.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
1.7.11.4

