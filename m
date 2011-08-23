Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1HWJ2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:28:14 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:10928 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab1HWJ2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:28:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20051.29353.630250.758016@pilspetsen.it.uu.se>
Date: Tue, 23 Aug 2011 11:28:09 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] correct register_hotplug_dock_device() prototype for CONFIG_ACPI_DOCK=n
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the following compiling kernel 3.1-rc3 on x86_64 with CONFIG_ACPI_DOCK=n:

drivers/ata/libata-acpi.c: In function 'ata_acpi_associate':
drivers/ata/libata-acpi.c:266:11: warning: passing argument 2 of 'register_hotplug_dock_device' discards 'const' qualifier from pointer target type [enabled by default]
include/acpi/acpi_drivers.h:146:19: note: expected 'struct acpi_dock_ops *' but argument is of type 'const struct acpi_dock_ops *'
drivers/ata/libata-acpi.c:275:11: warning: passing argument 2 of 'register_hotplug_dock_device' discards 'const' qualifier from pointer target type [enabled by default]
include/acpi/acpi_drivers.h:146:19: note: expected 'struct acpi_dock_ops *' but argument is of type 'const struct acpi_dock_ops *'

The two versions of register_hotplug_dock_device() in acpi_drivers.h,
depending on CONFIG_ACPI_DOCK, differ in whether the 2nd parameter is
const or not.  The dummy version for !DOCK lacked the const, causing
the warning.  Trivially fixed by adding the const.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---

--- linux-3.1-rc3/include/acpi/acpi_drivers.h.~1~	2011-08-23 10:42:23.000000000 +0200
+++ linux-3.1-rc3/include/acpi/acpi_drivers.h	2011-08-23 11:06:50.000000000 +0200
@@ -144,7 +144,7 @@ static inline void unregister_dock_notif
 {
 }
 static inline int register_hotplug_dock_device(acpi_handle handle,
-					       struct acpi_dock_ops *ops,
+					       const struct acpi_dock_ops *ops,
 					       void *context)
 {
 	return -ENODEV;
