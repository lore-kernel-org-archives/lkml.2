Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966017Ab1KJDsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:48:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965985Ab1KJDsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:06 2011
Message-Id: <20111109213206.639918536@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>
Subject: [240/264] ACPI: Fix CONFIG_ACPI_DOCK=n compiler warning
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit c1056b42a87b59375f8f81a92ef029165f44fcce upstream.

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

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/acpi/acpi_drivers.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -144,7 +144,7 @@ static inline void unregister_dock_notif
 {
 }
 static inline int register_hotplug_dock_device(acpi_handle handle,
-					       struct acpi_dock_ops *ops,
+					       const struct acpi_dock_ops *ops,
 					       void *context)
 {
 	return -ENODEV;


