Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1KBTaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:30:06 -0400
Received: from relay01ant.iops.be ([212.53.4.34]:40921 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab1KBTaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:30:03 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 15:30:03 EDT
From: Bart Van Assche <bvanassche@acm.org>
To: linux-acpi@vger.kernel.org
Subject: [PATCH, RESEND] ACPI: Fix CONFIG_ACPI_DOCK=n compiler warning
Date: Wed, 2 Nov 2011 20:16:05 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38.8-scst; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <201109231958.55067.bvanassche@acm.org>
In-Reply-To: <201109231958.55067.bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111022016.05979.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently the ACPI ops structs were constified but the inline version
of register_hotplug_dock_device() was overlooked (see also commit
9c8b04b, June 25 2011). Update the inline function
register_hotplug_dock_device() that is enabled with
CONFIG_ACPI_DOCK=n too. This patch fixes at least the following
compiler warnings:

drivers/ata/libata-acpi.c: In function .ata_acpi_associate.:
drivers/ata/libata-acpi.c:266:11: warning: passing argument 2 of .register_hotplug_dock_device. discards qualifiers from pointer target type
include/acpi/acpi_drivers.h:146:19: note: expected .struct acpi_dock_ops *. but argument is of type .const struct acpi_dock_ops *.
drivers/ata/libata-acpi.c:275:11: warning: passing argument 2 of .register_hotplug_dock_device. discards qualifiers from pointer target type
include/acpi/acpi_drivers.h:146:19: note: expected .struct acpi_dock_ops *. but argument is of type .const struct acpi_dock_ops *.

Cc: Len Brown <len.brown@intel.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
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
