Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab2BBTKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:10:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58032 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab2BBTKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:10:24 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] MCE, AMD: Select SMP explicitly
Date: Thu,  2 Feb 2012 20:10:17 +0100
Message-Id: <1328209817-18913-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap reported that building randconfigs which do not select
CONFIG_SMP cause the following link error:

mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'

Fix it.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Link: http://lkml.kernel.org/r/4F298A6C.6010101@xenotime.net
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..63fcb8a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -897,7 +897,7 @@ config X86_MCE_INTEL
 config X86_MCE_AMD
 	def_bool y
 	prompt "AMD MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
+	depends on X86_MCE && X86_LOCAL_APIC && SMP
 	---help---
 	   Additional support for AMD specific MCE features such as
 	   the DRAM Error Threshold.
-- 
1.7.9

