Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1DDJUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:20:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53145 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1DDJUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:20:17 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Subject: [PATCH] usb: Fix Kconfig unmet dependencies for Microblaze EHCI
Date: Mon,  4 Apr 2011 11:20:11 +0200
Message-Id: <1301908812-8119-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable USB_ARCH_HAS_EHCI in arch Kconfig and enable it in usb Kconfig

Warning log:
warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && FUNCTION_TRACER &&
KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL &&
(CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) ||
ARCH_WANT_FRAME_POINTERS)

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org
---
 arch/microblaze/Kconfig |    1 -
 drivers/usb/Kconfig     |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index c49c326..46b970e 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -6,7 +6,6 @@ config MICROBLAZE
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
-	select USB_ARCH_HAS_EHCI
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 41b6e51..006489d 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -66,6 +66,7 @@ config USB_ARCH_HAS_EHCI
 	default y if ARCH_VT8500
 	default y if PLAT_SPEAR
 	default y if ARCH_MSM
+	default y if MICROBLAZE
 	default PCI
 
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
-- 
1.5.5.6

