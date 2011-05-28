Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750858Ab1E1ETh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 00:19:37 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58022 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab1E1ETg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 00:19:36 -0400
Date: Fri, 27 May 2011 21:15:23 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH] acpi: create CONFIG item for debugfs custom_method
Message-ID: <20110528041523.GD19633@outflux.net>
References: <20110222193250.GA23913@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222193250.GA23913@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since /sys/kernel/debug/acpi/custom_method can be used to write arbitrary
kernel memory (http://jon.oberheide.org/files/american-sign-language.c),
it should be able to be left out of the kernel for system owners that
want to be as defensive as possible to potential attacks, even from the
root user. See as examples: CONFIG_DEVKMEM, CONFIG_STRICT_DEVMEM, and
/proc/sys/kernel/modules_disabled.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
Third time sending this, no response...
https://lkml.org/lkml/2011/2/22/369

 drivers/acpi/Kconfig   |   10 ++++++++++
 drivers/acpi/debugfs.c |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 2aa042a..726b7ea 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -381,6 +381,16 @@ config ACPI_HED
 	  which is used to report some hardware errors notified via
 	  SCI, mainly the corrected errors.
 
+config ACPI_DEBUG_CUSTOM_METHOD
+	bool "Debugging: Custom Method Insertion"
+	depends on DEBUG_FS
+	default n
+	help
+	  This creates the debugfs interface file "acpi/custom_method"
+	  used for loading custom ACPI methods. Note that this allows
+	  arbitrary kernel memory writing by the root user and is not
+	  recommended for normal systems.
+
 source "drivers/acpi/apei/Kconfig"
 
 endif	# ACPI
diff --git a/drivers/acpi/debugfs.c b/drivers/acpi/debugfs.c
index 5df67f1..0240b15 100644
--- a/drivers/acpi/debugfs.c
+++ b/drivers/acpi/debugfs.c
@@ -20,6 +20,7 @@ module_param_named(aml_debug_output, acpi_gbl_enable_aml_debug_object,
 MODULE_PARM_DESC(aml_debug_output,
 		 "To enable/disable the ACPI Debug Object output.");
 
+#ifdef CONFIG_ACPI_DEBUG_CUSTOM_METHOD
 /* /sys/kernel/debug/acpi/custom_method */
 
 static ssize_t cm_write(struct file *file, const char __user * user_buf,
@@ -92,3 +93,4 @@ err:
 		debugfs_remove(acpi_dir);
 	return -EINVAL;
 }
+#endif
-- 
1.7.2.3

-- 
Kees Cook
Ubuntu Security Team
