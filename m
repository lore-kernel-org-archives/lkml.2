Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750784Ab1IWR7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:59:07 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:46006 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1IWR7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:59:03 -0400
From: Bart Van Assche <bvanassche@acm.org>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: Fix CONFIG_ACPI_DOCK=n compiler warning
Date: Fri, 23 Sep 2011 19:58:55 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.8-scst; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Jeff Garzik <jgarzik@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109231958.55067.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently the ACPI ops structs were constified but the inline version
of register_hotplug_dock_device() was overlooked (see also commit
9c8b04be443b33939f374a811c82abeebe0a61d1, June 25 2011). Update
the inline function register_hotplug_dock_device() that is
enabled with CONFIG_ACPI_DOCK=n too. This patch fixes at
least the following compiler warnings:

drivers/ata/libata-acpi.c: In function .ata_acpi_associate.:
drivers/ata/libata-acpi.c:266:11: warning: passing argument 2 of .register_hotplug_dock_device. discards qualifiers from pointer target type
include/acpi/acpi_drivers.h:146:19: note: expected .struct acpi_dock_ops *. but argument is of type .const struct acpi_dock_ops *.
drivers/ata/libata-acpi.c:275:11: warning: passing argument 2 of .register_hotplug_dock_device. discards qualifiers from pointer target type
include/acpi/acpi_drivers.h:146:19: note: expected .struct acpi_dock_ops *. but argument is of type .const struct acpi_dock_ops *.

Cc: Len Brown <len.brown@intel.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: <stable@kernel.org>
---
 include/acpi/acpi_drivers.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index e49c36d..bb145e4 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -144,7 +144,7 @@ static inline void unregister_dock_notifier(struct notifier_block *nb)
 {
 }
 static inline int register_hotplug_dock_device(acpi_handle handle,
-					       struct acpi_dock_ops *ops,
+					       const struct acpi_dock_ops *ops,
 					       void *context)
 {
 	return -ENODEV;
-- 
1.7.3.4

