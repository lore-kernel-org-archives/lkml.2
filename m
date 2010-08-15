Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0HOFWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:22:15 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:48983 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0HOFWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:22:13 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 3/5] intel_idle: disable module support
Date: Sun, 15 Aug 2010 01:22:03 -0400
Message-id: <6ce9cd8669fa1195fdc21643370e34523c7ac988.1281849655.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.2.1.95.g3d045
In-reply-to: <1281849725-7379-1-git-send-email-lenb@kernel.org>
References: <1281849725-7379-1-git-send-email-lenb@kernel.org>
In-reply-to: <0394c6676e3fa48587fbe4821390d3264672c530.1281849655.git.len.brown@intel.com>
References: <0394c6676e3fa48587fbe4821390d3264672c530.1281849655.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Right now the module capability is cauing more trouble
than it is worth.  At least one distro built intel_idle as a module
where it lost the init race with ACPI, making it useless.

Make intel_idle bool so that if you select it, you will use it.

We can restore module capability after cpuidle is enhanced
to handle run-time changing of idle drivers.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/Kconfig b/drivers/idle/Kconfig
index fb5c518..82e4e86 100644
--- a/drivers/idle/Kconfig
+++ b/drivers/idle/Kconfig
@@ -1,5 +1,5 @@
 config INTEL_IDLE
-	tristate "Cpuidle Driver for Intel Processors"
+	bool "Cpuidle Driver for Intel Processors"
 	depends on CPU_IDLE
 	depends on X86
 	depends on CPU_SUP_INTEL
-- 
1.7.2.1.95.g3d045

