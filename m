Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab1GTRoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:44:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:44709 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab1GTRoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:44:02 -0400
Date: Wed, 20 Jul 2011 17:43:41 GMT
Message-Id: <201107201743.p6KHhfIs002214@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL RESEND] x86 fixes for 3.0-final
Cc: Conny Seidel <conny.seidel@amd.com>, Darren Hart <dvhart@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jul 2011 17:43:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit e3bbfa78bab125f58b831b5f7f45b5a305091d72:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-07-10 10:24:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

Darren Hart (1):
      x86, doc only: Correct real-mode kernel header offset for init_size

Maxime Ripard (1):
      x86. reboot: Make Dell Latitude E6320 use reboot=pci

Tejun Heo (1):
      x86: Disable AMD_NUMA for 32bit for now

 Documentation/x86/boot.txt |    2 +-
 arch/x86/Kconfig           |    2 +-
 arch/x86/kernel/reboot.c   |    8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9b7221a..7c3a880 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -674,7 +674,7 @@ Protocol:	2.10+
 
 Field name:	init_size
 Type:		read
-Offset/size:	0x25c/4
+Offset/size:	0x260/4
 
   This field indicates the amount of linear contiguous memory starting
   at the kernel runtime start address that the kernel needs before it
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..37357a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1170,7 +1170,7 @@ comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 config AMD_NUMA
 	def_bool y
 	prompt "Old style AMD Opteron NUMA detection"
-	depends on NUMA && PCI
+	depends on X86_64 && NUMA && PCI
 	---help---
 	  Enable AMD NUMA node topology detection.  You should say Y here if
 	  you have a multi processor AMD system. This uses an old method to
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 4f0d46f..14eed21 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -419,6 +419,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E6320. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E6320",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
+		},
+	},
 	{ }
 };
 
