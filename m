Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab1G2Qes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:34:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34456 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1G2Qeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:34:46 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-next@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Jeff Garzik <jgarzik@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH][-next] acpi/acpi_drivers.h: fix warnings when ACPI_DOCK is not enabled
Date: Fri, 29 Jul 2011 12:34:38 -0400
Message-Id: <1311957278-12290-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/src/linux/linux/drivers/ata/libata-acpi.c: In function 'ata_acpi_associate':
/src/linux/linux/drivers/ata/libata-acpi.c:266:11: warning: passing argument 2 of 'register_hotplug_dock_device' discards 'const' qualifier from pointer target type [enabled by default]
/src/linux/linux/include/acpi/acpi_drivers.h:146:19: note: expected 'struct acpi_dock_ops *' but argument is of type 'const struct acpi_dock_ops *'
/src/linux/linux/drivers/ata/libata-acpi.c:275:11: warning: passing argument 2 of 'register_hotplug_dock_device' discards 'const' qualifier from pointer target type [enabled by default]
/src/linux/linux/include/acpi/acpi_drivers.h:146:19: note: expected 'struct acpi_dock_ops *' but argument is of type 'const struct acpi_dock_ops *'

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
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
1.7.6.153.g78432

