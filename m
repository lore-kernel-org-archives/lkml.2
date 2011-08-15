Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1HOPb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:31:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60578 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752720Ab1HOPb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:31:26 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19R2+MSGz9R+ze3IBzpbHGNiXVIKXRt8eX9tVsNce
	oWbTBFw3Z4dBvc
From: Peter Huewe <peterhuewe@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peterhuewe@gmx.de
Subject: [PATCH] arm: footbridge: Netwinder: Add KConfig select CLKEVT_I8253 to fix build failure
Date: Mon, 15 Aug 2011 17:31:20 +0200
Message-Id: <1313422280-21942-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build failure for the netwinder_defconfig by adding
the necessary select CLKEVT_I8253 statement to the KCONFIG option.

Without this patch the build fails with this linker error:
isa-rtc.c:(.init.text+0x11d4): undefined reference to
`clockevent_i8253_init'
isa-rtc.c:(.init.text+0x11dc): undefined reference to `i8253_clockevent'
arch/arm/mach-footbridge/built-in.o:(.data+0x18c): undefined reference
to `i8253_clockevent'

This is because the functions are guarded by a #ifdef
CONFIG_CLKEVT_I8253

KernelVersion: Linux-next 20110812
but this is also present in Linus' current tree since July 1st.
(since commit e6220bd "i8253: Create common clockevent implementation")

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/arm/mach-footbridge/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index dc26fff..c8e7afc 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -62,6 +62,7 @@ config ARCH_EBSA285_HOST
 config ARCH_NETWINDER
 	bool "NetWinder"
 	select CLKSRC_I8253
+	select CLKEVT_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
-- 
1.7.3.4

