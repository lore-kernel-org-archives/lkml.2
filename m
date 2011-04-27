Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1D0OuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:50:25 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36854 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1D0OuY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 27 Apr 2011 10:50:24 -0400
Message-Id: <4DB84999020000780003E666@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 15:51:37 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: tighten dependencies of CPU_SUP_*_32
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building in support for any of these CPUs is pointless when e.g. M686
was selected (as such a kernel would use cmov instructions, which
aren't available on these older CPUs).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig.cpu |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 2.6.39-rc5/arch/x86/Kconfig.cpu
+++ 2.6.39-rc5-i386-cpu-sup-dependencies/arch/x86/Kconfig.cpu
@@ -440,7 +440,7 @@ config CPU_SUP_INTEL
 config CPU_SUP_CYRIX_32
 	default y
 	bool "Support Cyrix processors" if PROCESSOR_SELECT
-	depends on !64BIT
+	depends on M386 || M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for Cyrix processors
 
@@ -480,7 +480,7 @@ config CPU_SUP_CENTAUR
 config CPU_SUP_TRANSMETA_32
 	default y
 	bool "Support Transmeta processors" if PROCESSOR_SELECT
-	depends on !64BIT
+	depends on M386 || M486 || M586 || M586TSC || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for Transmeta processors
 
@@ -494,7 +494,7 @@ config CPU_SUP_TRANSMETA_32
 config CPU_SUP_UMC_32
 	default y
 	bool "Support UMC processors" if PROCESSOR_SELECT
-	depends on !64BIT
+	depends on M386 || M486 || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for UMC processors
 



