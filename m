Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1L3J7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 04:59:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab1L3J7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 04:59:04 -0500
Date: Fri, 30 Dec 2011 01:58:46 -0800
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-kpnaimplltk6d1lolusqj3ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/intel config: Fix the APB_TIMER selection
Git-Commit-ID: 7c9c3a1e5fc8728e948b8fa3cbcfcfb86db3afda
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 30 Dec 2011 01:58:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c9c3a1e5fc8728e948b8fa3cbcfcfb86db3afda
Gitweb:     http://git.kernel.org/tip/7c9c3a1e5fc8728e948b8fa3cbcfcfb86db3afda
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Thu, 29 Dec 2011 14:43:16 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Dec 2011 21:53:17 +0100

x86/intel config: Fix the APB_TIMER selection

Seems Kconfig SELECT isn't selecting things hierarchically when
selected.

config APB_TIMER
       def_bool y if X86_INTEL_MID
       prompt "Intel MID APB Timer Support" if X86_INTEL_MID
       select DW_APB_TIMER
       depends on X86_INTEL_MID && SFI

when we select APB_TIMER doesn't select DW_APB_TIMER so do it by
hand.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-kpnaimplltk6d1lolusqj3ae@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 07620bc..78fbb34 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -409,12 +409,14 @@ config X86_MRST
 	depends on PCI
 	depends on PCI_GOANY
 	depends on X86_IO_APIC
+	select X86_INTEL_MID
+	select SFI
+	select DW_APB_TIMER
 	select APB_TIMER
 	select I2C
 	select SPI
 	select INTEL_SCU_IPC
 	select X86_PLATFORM_DEVICES
-	select X86_INTEL_MID
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
@@ -428,12 +430,14 @@ config X86_MDFLD
 	depends on PCI
 	depends on PCI_GOANY
 	depends on X86_IO_APIC
+	select X86_INTEL_MID
+	select SFI
+	select DW_APB_TIMER
 	select APB_TIMER
 	select I2C
 	select SPI
 	select INTEL_SCU_IPC
 	select X86_PLATFORM_DEVICES
-	select X86_INTEL_MID
 	---help---
 	  Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. 
