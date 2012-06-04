Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2FDF1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:27:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:41685 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab2FDF1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:27:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="160218313"
Date: Mon, 4 Jun 2012 13:23:41 +0800
From: Feng Tang <feng.tang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <rui.zhang@intel.com>, <fazerxlo@o2.pl>, <x86@kernel.org>
Subject: [PATCH 3/3] ACPI: Add a quirk for "AMILO PRO V2030" to ignore the
 timer overriding
Message-ID: <20120604132341.70d5c05f@feng-i7>
In-Reply-To: <4FC8F36C.8080409@kernel.org>
References: <1338259418-6167-1-git-send-email-feng.tang@intel.com>
	<4FC8F36C.8080409@kernel.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cfca8634132c1b2f89c39f681ae2aa1fe227c9f5 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Mon, 4 Jun 2012 11:06:35 +0800
Subject: [PATCH 3/3] ACPI: Add a quirk for "AMILO PRO V2030" to ignore the
 timer overriding

This is the 2nd part of fix for kernel bugzilla 40002:
    "IRQ 0 assigned to VGA"
https://bugzilla.kernel.org/show_bug.cgi?id=40002

The root cause is the buggy FW, whose ACPI tables assign the GSI 16
to 2 irqs 0 and 16(VGA), and the VGA is the right owner of GSI 16.
So add a quirk to ignore the irq0 overriding GSI 16 for the
FUJITSU SIEMENS AMILO PRO V2030 platform will solve this issue.

Reported-and-tested-by: Szymon Kowalczyk <fazerxlo@o2.pl>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/acpi/boot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 3a6afba..b2297e5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1470,6 +1470,14 @@ static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
 		     },
 	 },
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "FUJITSU SIEMENS",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
+		     },
+	 },
 	{}
 };
 
-- 
1.7.9
