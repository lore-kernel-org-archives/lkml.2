Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736Ab1J1WtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 18:49:06 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:65257 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab1J1WtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 18:49:05 -0400
Date: Sat, 29 Oct 2011 00:48:42 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, johnstul@us.ibm.com
Subject: [PATCH] x86 Kconfig: cyclone-timer depends on x86-summit
Message-ID: <20111028224842.GA7582@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_X86_CYCLONE_TIMER depends on CONFIG_X86_32_NON_STANDARD,
which forces drivers/clocksource/cyclone.c to be compiled. The
file doesn't do anything unless enabled by arch/x86/kernel/apic/summit_32.c

Make CONFIG_X86_CYCLONE_TIMER depend by X86_SUMMIT instead, to avoid
unnecessary code in other non-standard systems.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: john stultz <johnstul@us.ibm.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f497677..5c67a1f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -619,7 +619,7 @@ config X86_SUMMIT_NUMA
 
 config X86_CYCLONE_TIMER
 	def_bool y
-	depends on X86_32_NON_STANDARD
+	depends on X86_SUMMIT
 
 source "arch/x86/Kconfig.cpu"
 
-- 
1.5.6.5
