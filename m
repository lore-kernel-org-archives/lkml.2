Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab2CHJRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:17:20 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:60423 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2CHJRP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 8 Mar 2012 04:17:15 -0500
Message-Id: <4F58875A02000078000770E0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 08 Mar 2012 09:18:02 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2, resend] ix86: tighten dependencies of CPU_SUP_*_32
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building in support for either of these CPUs is pointless when e.g.
M686 was selected (since such a kernel would use cmov instructions,
which aren't available on these older CPUs).

v2: Drop (inappropriate) change to CPU_SUP_TRANSMETA_32.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/Kconfig.cpu |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.3-rc6/arch/x86/Kconfig.cpu
+++ 3.3-rc6-ix86-cpu-sup-dependencies/arch/x86/Kconfig.cpu
@@ -441,7 +441,7 @@ config CPU_SUP_INTEL
 config CPU_SUP_CYRIX_32
 	default y
 	bool "Support Cyrix processors" if PROCESSOR_SELECT
-	depends on !64BIT
+	depends on M386 || M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for Cyrix processors
 
@@ -495,7 +495,7 @@ config CPU_SUP_TRANSMETA_32
 config CPU_SUP_UMC_32
 	default y
 	bool "Support UMC processors" if PROCESSOR_SELECT
-	depends on !64BIT
+	depends on M386 || M486 || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for UMC processors
 



