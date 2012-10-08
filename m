Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2JHRLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:11:53 -0400
Received: from mail.x86-64.org ([217.9.48.20]:60582 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab2JHRLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:11:48 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/6] x86, RAS: Add a barebones RAS subtree
Date: Mon,  8 Oct 2012 19:11:28 +0200
Message-Id: <1349716293-16723-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349716293-16723-1-git-send-email-bp@amd64.org>
References: <1349716293-16723-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This should collect all x86 RAS-related stuff.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig      | 8 ++++++++
 arch/x86/Makefile     | 3 +++
 arch/x86/ras/Makefile | 1 +
 3 files changed, 12 insertions(+)
 create mode 100644 arch/x86/ras/Makefile
 create mode 100644 arch/x86/ras/ras.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e0323d67ee42..e5cae3de52ff 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -687,6 +687,14 @@ config X86_CYCLONE_TIMER
 	def_bool y
 	depends on X86_SUMMIT
 
+config X86_RAS
+	def_bool y
+	prompt "X86 RAS features"
+	---help---
+	A collection of Reliability, Availability and Serviceability software
+	features which enable hardware error logging and reporting. Leave it
+	at 'y' unless you really know what you're doing.
+
 source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 58790bd85c1d..2810e50b670d 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -163,6 +163,9 @@ libs-y  += arch/x86/lib/
 # See arch/x86/Kbuild for content of core part of the kernel
 core-y += arch/x86/
 
+# RAS support
+core-$(CONFIG_X86_RAS)		+= arch/x86/ras/
+
 # drivers-y are linked after core-y
 drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
 drivers-$(CONFIG_PCI)            += arch/x86/pci/
diff --git a/arch/x86/ras/Makefile b/arch/x86/ras/Makefile
new file mode 100644
index 000000000000..7a70bb5cd057
--- /dev/null
+++ b/arch/x86/ras/Makefile
@@ -0,0 +1 @@
+obj-y		:= ras.o
diff --git a/arch/x86/ras/ras.c b/arch/x86/ras/ras.c
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
1.8.0.rc0.18.gf84667d

