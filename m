Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2IGGrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:47:10 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48617 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2IGGrH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 7 Sep 2012 02:47:07 -0400
Message-Id: <5049B4C102000078000998FE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 07 Sep 2012 07:48:01 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: improve determination of X86_MINIMUM_CPU_FAMILY
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was quite a bit off: While I never build for anything older than
i686 (other than for specifically trying certain things out), one of my
32-bit configs (tailor made for a VIA system) ended up having this set
to 4. Others, customized for more mainstream systems, had this set to 5.

Once at it, also drop the unnecessary dependencies on X86_32 - that
symbol being the inverse of X86_64, and Kconfig default determination
working by a first match algorithm, X86_64 being dealt with in the very
first selection makes it unnecessary to have that dependency in all
subsequent default selections.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/Kconfig.cpu |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 3.6-rc4/arch/x86/Kconfig.cpu
+++ 3.6-rc4-x86-minimum-cpu-family/arch/x86/Kconfig.cpu
@@ -409,9 +409,9 @@ config X86_CMOV
 config X86_MINIMUM_CPU_FAMILY
 	int
 	default "64" if X86_64
-	default "6" if X86_32 && X86_P6_NOP
-	default "5" if X86_32 && X86_CMPXCHG64
-	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
+	default "6" if X86_P6_NOP || X86_CMOV
+	default "5" if X86_CMPXCHG64 || X86_TSC
+	default "4" if X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK
 	default "3"
 
 config X86_DEBUGCTLMSR



