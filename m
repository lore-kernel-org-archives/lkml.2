Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1GWJbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 05:31:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38966 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab1GWJaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 05:30:55 -0400
Date: Sat, 23 Jul 2011 11:30:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform change for v3.1
Message-ID: <20110723093010.GA20292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-platform-for-linus

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86, config: Introduce an INTEL_MID configuration


 arch/x86/Kconfig |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 37357a5..80ef419 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -384,12 +384,21 @@ config X86_INTEL_CE
 	  This option compiles in support for the CE4100 SOC for settop
 	  boxes and media devices.
 
+config X86_INTEL_MID
+	bool "Intel MID platform support"
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	---help---
+	  Select to build a kernel capable of supporting Intel MID platform
+	  systems which do not have the PCI legacy interfaces (Moorestown,
+	  Medfield). If you are building for a PC class system say N here.
+
+if X86_INTEL_MID
+
 config X86_MRST
        bool "Moorestown MID platform"
 	depends on PCI
 	depends on PCI_GOANY
-	depends on X86_32
-	depends on X86_EXTENDED_PLATFORM
 	depends on X86_IO_APIC
 	select APB_TIMER
 	select I2C
@@ -404,6 +413,8 @@ config X86_MRST
 	  nor standard legacy replacement devices/features. e.g. Moorestown does
 	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
 
+endif
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
