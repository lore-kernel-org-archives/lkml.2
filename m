Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2L0Cqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:46:42 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:37610 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2L0Cp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:45:27 -0500
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 21:45:22 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, maxim.uvarov@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v3 08/11] x86/xen: Add kexec/kdump Kconfig and makefile rules
Date: Thu, 27 Dec 2012 03:18:57 +0100
Message-Id: <1356574740-6806-9-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1356574740-6806-8-git-send-email-daniel.kiper@oracle.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-2-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-3-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-4-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-5-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-6-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-7-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-8-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.499592
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kexec/kdump Kconfig and makefile rules.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/Kconfig      |    3 +++
 arch/x86/xen/Kconfig  |    1 +
 arch/x86/xen/Makefile |    3 +++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..e2746c4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1600,6 +1600,9 @@ config KEXEC_JUMP
 	  Jump between original kernel and kexeced kernel and invoke
 	  code in physical address mode via KEXEC
 
+config KEXEC_FIRMWARE
+	def_bool n
+
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EXPERT || CRASH_DUMP)
 	default "0x1000000"
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 131dacd..8469c1c 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -7,6 +7,7 @@ config XEN
 	select PARAVIRT
 	select PARAVIRT_CLOCK
 	select XEN_HAVE_PVMMU
+	select KEXEC_FIRMWARE if KEXEC
 	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
 	depends on X86_TSC
 	help
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 96ab2c0..99952d7 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -22,3 +22,6 @@ obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_XEN_DOM0)		+= apic.o vga.o
 obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
+obj-$(CONFIG_KEXEC_FIRMWARE)	+= kexec.o
+obj-$(CONFIG_KEXEC_FIRMWARE)	+= machine_kexec_$(BITS).o
+obj-$(CONFIG_KEXEC_FIRMWARE)	+= relocate_kernel_$(BITS).o
-- 
1.5.6.5

