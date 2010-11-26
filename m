Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab0KZV4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:56:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33232 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab0KZV4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:56:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] Platform / x86: Make fujitsu_laptop use acpi_bus_update_power()
Date: Fri, 26 Nov 2010 22:55:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201011250001.11297.rjw@sisk.pl>
In-Reply-To: <201011250001.11297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011262255.20848.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use the new function acpi_bus_update_power(), which is safer than
acpi_bus_get_power(), for getting device power state in
acpi_fujitsu_add().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---

Hi Len,

This patch should go after [11/13] in the "ACPI / PM: Rework power resources
management" series.  I hope Matthew won't mind if it goes in through your tree.

Thanks,
Rafael

---
 drivers/platform/x86/fujitsu-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/platform/x86/fujitsu-laptop.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/fujitsu-laptop.c
+++ linux-2.6/drivers/platform/x86/fujitsu-laptop.c
@@ -689,7 +689,7 @@ static int acpi_fujitsu_add(struct acpi_
 	if (error)
 		goto err_free_input_dev;
 
-	result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
+	result = acpi_bus_update_power(fujitsu->acpi_handle, &state);
 	if (result) {
 		printk(KERN_ERR "Error reading power state\n");
 		goto err_unregister_input_dev;
@@ -857,7 +857,7 @@ static int acpi_fujitsu_hotkey_add(struc
 	if (error)
 		goto err_free_input_dev;
 
-	result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);
+	result = acpi_bus_update_power(fujitsu_hotkey->acpi_handle, &state);
 	if (result) {
 		printk(KERN_ERR "Error reading power state\n");
 		goto err_unregister_input_dev;
