Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2FDFks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:40:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56777 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2FDFko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:44 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 15/15] ACPI: fix acpi_bus.h build warnings when ACPI is not enabled
Date: Mon,  4 Jun 2012 01:40:06 -0400
Message-Id: <7ae30986dc63d214cb075a40f2cf205f0a7806cd.1338786832.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
In-Reply-To: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
References: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

introduced in Linux-3.5-rc1 by
66886d6f8c9bcdee3d7fce5796dcffd6b4bc0b48
(ACPI: Add stubs for (un)register_acpi_bus_type)

Fix header file warnings when CONFIG_ACPI is not enabled:

include/acpi/acpi_bus.h:443:42: warning: 'struct acpi_bus_type' declared inside parameter list
include/acpi/acpi_bus.h:443:42: warning: its scope is only this definition or declaration, which is probably not
include/acpi/acpi_bus.h:444:44: warning: 'struct acpi_bus_type' declared inside parameter list

Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/acpi_bus.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index b0d6282..9e6e1c6 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -440,8 +440,8 @@ static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 
 #else	/* CONFIG_ACPI */
 
-static int register_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
-static int unregister_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
+static inline int register_acpi_bus_type(void *bus) { return 0; }
+static inline int unregister_acpi_bus_type(void *bus) { return 0; }
 
 #endif				/* CONFIG_ACPI */
 
-- 
1.7.11.rc0.100.g5498c5f

