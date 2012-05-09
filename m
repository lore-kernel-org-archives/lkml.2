Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab2EIJBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:01:54 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40580 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928Ab2EIJBv convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 9 May 2012 05:01:51 -0400
Message-Id: <4FAA4B82020000780008270B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 09:48:34 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <johnstul@us.ibm.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: [PATCH 4/5, resend] acpi_pm: adjust PCI quirk handler section
 annotations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation to adjust modpost to check section mismatches
on most of the .pci_fixup* sections:

.pci_fixup_final is only used from .init.text, and hence can (along
with the respective handler functions) reside in .init.*.

Several other .pci_fixup_* sections are needed only during boot and
suspend/resume, and can therefore be moved into .init.* if
!CONFIG_PM.

Handler (and eventual static data) section annotations need to/can be
changed accordingly.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/clocksource/acpi_pm.c     |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 3.4-rc6/drivers/clocksource/acpi_pm.c
+++ 3.4-rc6-pci-fixup-sections/drivers/clocksource/acpi_pm.c
@@ -73,7 +73,7 @@ static struct clocksource clocksource_ac
 
 
 #ifdef CONFIG_PCI
-static int __devinitdata acpi_pm_good;
+static int acpi_pm_good;
 static int __init acpi_pm_good_setup(char *__str)
 {
 	acpi_pm_good = 1;
@@ -102,7 +102,7 @@ static inline void acpi_pm_need_workarou
  * incorrect when read). As a result, the ACPI free running count up
  * timer specification is violated due to erroneous reads.
  */
-static void __devinit acpi_pm_check_blacklist(struct pci_dev *dev)
+static void acpi_pm_check_blacklist(struct pci_dev *dev)
 {
 	if (acpi_pm_good)
 		return;
@@ -120,7 +120,7 @@ static void __devinit acpi_pm_check_blac
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3,
 			acpi_pm_check_blacklist);
 
-static void __devinit acpi_pm_check_graylist(struct pci_dev *dev)
+static void acpi_pm_check_graylist(struct pci_dev *dev)
 {
 	if (acpi_pm_good)
 		return;



