Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1GUKM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:12:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:54129 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1GUKMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:12:25 -0400
Date: Thu, 21 Jul 2011 10:12:10 GMT
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-43605ef188cd39708ddc5e3adc47b337b6ebe40e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110712164859.7642.84136.stgit@bob.linux.org.uk>
References: <20110712164859.7642.84136.stgit@bob.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, config: Introduce an INTEL_MID configuration
Git-Commit-ID: 43605ef188cd39708ddc5e3adc47b337b6ebe40e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:12:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43605ef188cd39708ddc5e3adc47b337b6ebe40e
Gitweb:     http://git.kernel.org/tip/43605ef188cd39708ddc5e3adc47b337b6ebe40e
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Tue, 12 Jul 2011 17:49:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 10:35:14 +0200

x86, config: Introduce an INTEL_MID configuration

We need to carve up the configuration between:

 - MID general
 - Moorestown specific
 - Medfield specific
 - Future devices

As a base point create an INTEL_MID configuration property. We
make the existing MRST configuration a sub-option. This means
that the rest of the kernel config can still use X86_MRST checks
without anything going backwards.

After this is merged future patches will tidy up which devices
are MID and which are X86_MRST, as well as add options for
Medfield.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/20110712164859.7642.84136.stgit@bob.linux.org.uk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
