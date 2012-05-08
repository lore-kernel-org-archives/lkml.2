Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab2EHPYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:24:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62151 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab2EHPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:24:49 -0400
Message-ID: <1336490660.1179.39.camel@mop>
Subject: [PATCH] acpi: use KERN_CONT in printk() continuation lines
From: Kay Sievers <kay@vrfy.org>
To: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 17:24:20 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay@vrfy.org>
Subject: acpi: use KERN_CONT in printk() continuation lines

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 drivers/acpi/pci_link.c |   12 ++++++------
 drivers/acpi/sleep.c    |    8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -720,21 +720,21 @@ static int acpi_pci_link_add(struct acpi
 	       acpi_device_bid(device));
 	for (i = 0; i < link->irq.possible_count; i++) {
 		if (link->irq.active == link->irq.possible[i]) {
-			printk(" *%d", link->irq.possible[i]);
+			printk(KERN_CONT " *%d", link->irq.possible[i]);
 			found = 1;
 		} else
-			printk(" %d", link->irq.possible[i]);
+			printk(KERN_CONT " %d", link->irq.possible[i]);
 	}
 
-	printk(")");
+	printk(KERN_CONT ")");
 
 	if (!found)
-		printk(" *%d", link->irq.active);
+		printk(KERN_CONT " *%d", link->irq.active);
 
 	if (!link->device->status.enabled)
-		printk(", disabled.");
+		printk(KERN_CONT ", disabled.");
 
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	list_add_tail(&link->list, &acpi_link_list);
 
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -887,7 +887,7 @@ int __init acpi_sleep_init(void)
 		status = acpi_get_sleep_type_data(i, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
 			sleep_states[i] = 1;
-			printk(" S%d", i);
+			printk(KERN_CONT " S%d", i);
 		}
 	}
 
@@ -901,7 +901,7 @@ int __init acpi_sleep_init(void)
 		hibernation_set_ops(old_suspend_ordering ?
 			&acpi_hibernation_ops_old : &acpi_hibernation_ops);
 		sleep_states[ACPI_STATE_S4] = 1;
-		printk(" S4");
+		printk(KERN_CONT " S4");
 		if (!nosigcheck) {
 			acpi_get_table(ACPI_SIG_FACS, 1,
 				(struct acpi_table_header **)&facs);
@@ -914,11 +914,11 @@ int __init acpi_sleep_init(void)
 	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
 	if (ACPI_SUCCESS(status)) {
 		sleep_states[ACPI_STATE_S5] = 1;
-		printk(" S5");
+		printk(KERN_CONT " S5");
 		pm_power_off_prepare = acpi_power_off_prepare;
 		pm_power_off = acpi_power_off;
 	}
-	printk(")\n");
+	printk(KERN_CONT ")\n");
 	/*
 	 * Register the tts_notifier to reboot notifier list so that the _TTS
 	 * object can also be evaluated when the system enters S5.


