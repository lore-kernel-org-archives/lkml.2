Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1FIOdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:33:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1FIOdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:33:07 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, pjones@redhat.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] x86: CONFIG_EFI should select CONFIG_RELOCATABLE
Date: Thu,  9 Jun 2011 10:32:44 -0400
Message-Id: <1307629964-31658-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI doesn't provide any guarantees that any given address will be free,
so the bootloader must have the freedom to position the kernel
appropriately. Make CONFIG_EFI select CONFIG_RELOCATABLE in order to
ensure that this constraint is satisfiable.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..580cd31 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1454,6 +1454,7 @@ config ARCH_USES_PG_UNCACHED
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
+	select RELOCATABLE
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
-- 
1.7.5.2

