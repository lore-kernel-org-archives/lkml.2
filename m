Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2GWBmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54071 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab2GWBmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:33 -0400
Message-Id: <20120723010705.672117432@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Feng Tang <feng.tang@intel.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 093/108] ACPI: Add a quirk for "AMILO PRO V2030" to ignore the timer
 overriding
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit b939c2acf1dc42b08407ef5174f2e8d6f43dd5ea upstream.

commit f6b54f083cc66cf9b11d2120d8df3c2ad4e0836d upstream.

This is the 2nd part of fix for kernel bugzilla 40002:
    "IRQ 0 assigned to VGA"
https://bugzilla.kernel.org/show_bug.cgi?id=40002

The root cause is the buggy FW, whose ACPI tables assign the GSI 16
to 2 irqs 0 and 16(VGA), and the VGA is the right owner of GSI 16.
So add a quirk to ignore the irq0 overriding GSI 16 for the
FUJITSU SIEMENS AMILO PRO V2030 platform will solve this issue.

Reported-and-tested-by: Szymon Kowalczyk <fazerxlo@o2.pl>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/acpi/boot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 2b84bc3..bbdffc2 100644
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
 


