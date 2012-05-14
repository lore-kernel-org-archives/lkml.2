Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab2ENUtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:49:05 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43721 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757829Ab2ENUtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:49:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: [PATCH] ACPI / PM: Fix error message in __acpi_bus_set_power()
Date: Mon, 14 May 2012 22:53:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205142253.57023.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After recent changes of the ACPI device low-power states definitions
an error message in __acpi_bus_set_power() needs to be updated so
that it prints the correct name of the state that has been requested
(currently it will print "D3" for D3hot and "D4" for D3cold).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/bus.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/drivers/acpi/bus.c
===================================================================
--- linux.orig/drivers/acpi/bus.c
+++ linux/drivers/acpi/bus.c
@@ -240,7 +240,9 @@ static int __acpi_bus_set_power(struct a
 	}
 
 	if (!device->power.states[state].flags.valid) {
-		printk(KERN_WARNING PREFIX "Device does not support D%d\n", state);
+		printk(KERN_WARNING PREFIX "Device does not support D%d%s\n",
+			state == ACPI_STATE_D3_COLD ? 3 : state,
+			state == ACPI_STATE_D3_HOT ? "hot" : "");
 		return -ENODEV;
 	}
 	if (device->parent && (state < device->parent->power.state)) {
