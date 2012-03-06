Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031558Ab2CFWtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:49:31 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58692 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031500Ab2CFWt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:49:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mathieu.poirier@linaro.org designates 10.182.89.65 as permitted sender) smtp.mail=mathieu.poirier@linaro.org
MIME-Version: 1.0
From: mathieu.poirier@linaro.org
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, grant.likely@secretlab.ca
Subject: [PATCH] ARM: versatile: automatically pick a board in Kconfig
Date: Tue,  6 Mar 2012 15:49:22 -0700
Message-Id: <1331074162-18147-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The versatile platform supports building any combination of the
three board types (AB, PB, DT), but at least one of them has
to be enabled. This adds the necessary Kconfig statement to
enforce that at least one of the three is selected.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/mach-versatile/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-versatile/Kconfig b/arch/arm/mach-versatile/Kconfig
index c1f38f6..31da352 100644
--- a/arch/arm/mach-versatile/Kconfig
+++ b/arch/arm/mach-versatile/Kconfig
@@ -25,4 +25,10 @@ config MACH_VERSATILE_DT
 	  Include support for the ARM(R) Versatile/PB platform,
 	  using the device tree for discovery
 
+config MACH_VERSATILE_AUTO
+	def_bool y
+	depends on !ARCH_VERSATILE_PB
+	depends on !MACH_VERSATILE_AB
+	select MACH_VERSATILE_DT
+
 endmenu
-- 
1.7.5.4

