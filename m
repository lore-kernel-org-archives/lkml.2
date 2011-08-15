Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1HOPkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:40:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53275 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752438Ab1HOPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:40:15 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18k32s/IDEkfyTQac9o6wQJUZhM2wjZ1qA8XACasL
	JU+EpDel9R7w5w
From: Peter Huewe <peterhuewe@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH v2] arm: footbridge: Netwinder: Add KConfig select CLKEVT_I8253 to fix build failure
Date: Mon, 15 Aug 2011 17:40:10 +0200
Message-Id: <1313422810-28916-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110815153338.GA525@n2100.arm.linux.org.uk>
References: <20110815153338.GA525@n2100.arm.linux.org.uk>
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

v2:
Added the option in the right alphabetical order.
I also adjusted the alphabetical order for ARCH_CATS so both are
similar

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/arm/mach-footbridge/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index dc26fff..f643ef8 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -4,8 +4,8 @@ menu "Footbridge Implementations"
 
 config ARCH_CATS
 	bool "CATS"
-	select CLKSRC_I8253
 	select CLKEVT_I8253
+	select CLKSRC_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
@@ -61,6 +61,7 @@ config ARCH_EBSA285_HOST
 
 config ARCH_NETWINDER
 	bool "NetWinder"
+	select CLKEVT_I8253
 	select CLKSRC_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
-- 
1.7.3.4

