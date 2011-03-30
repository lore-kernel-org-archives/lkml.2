Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab1C3WUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:20:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59574 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab1C3WUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:20:36 -0400
Date: Wed, 30 Mar 2011 15:20:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        platform-driver-x86@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, "Lee, Chun-Yi" <jlee@novell.com>
Subject: [PATCH -rc1] msi-laptop: fix config-dependent build error
Message-Id: <20110330152022.9b3e6942.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
References: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D93ACA8.0153:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The msi-laptop driver uses input_*() and sparse_keymap_*() interfaces.
It should depend on the INPUT subsystem being present and select
INPUT_SPARSEKMAP so that those interfaces are present.

ERROR: "input_free_device" [drivers/platform/x86/msi-laptop.ko] undefined!
ERROR: "input_register_device" [drivers/platform/x86/msi-laptop.ko] undefined!
ERROR: "sparse_keymap_setup" [drivers/platform/x86/msi-laptop.ko] undefined!
ERROR: "input_allocate_device" [drivers/platform/x86/msi-laptop.ko] undefined!
ERROR: "sparse_keymap_report_event" [drivers/platform/x86/msi-laptop.ko] undefined!
ERROR: "input_unregister_device" [drivers/platform/x86/msi-laptop.ko] undefined!
ERROR: "sparse_keymap_free" [drivers/platform/x86/msi-laptop.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: "Lee, Chun-Yi" <jlee@novell.com>
---
 drivers/platform/x86/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- lnx-2639-rc1.orig/drivers/platform/x86/Kconfig
+++ lnx-2639-rc1/drivers/platform/x86/Kconfig
@@ -187,7 +187,8 @@ config MSI_LAPTOP
 	depends on ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL
-	depends on SERIO_I8042
+	depends on INPUT && SERIO_I8042
+	select INPUT_SPARSEKMAP
 	---help---
 	  This is a driver for laptops built by MSI (MICRO-STAR
 	  INTERNATIONAL):
