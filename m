Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2JPOxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:53:01 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45234 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab2JPOw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:52:58 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v2 1/6] x86, RAS: Add a barebones RAS subtree
Date: Tue, 16 Oct 2012 16:52:50 +0200
Message-Id: <1350399175-14477-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc2.4.g42e55a5
In-Reply-To: <1350399175-14477-1-git-send-email-bp@amd64.org>
References: <1350399175-14477-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This should collect all x86 RAS-related stuff.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig  | 6 ++++++
 arch/x86/Makefile | 3 +++
 2 files changed, 9 insertions(+)
 create mode 100644 arch/x86/ras/Makefile

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1ae94bcae5d9..e882fc64ffb3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -660,6 +660,12 @@ config X86_CYCLONE_TIMER
 	def_bool y
 	depends on X86_SUMMIT
 
+config X86_RAS
+	bool "X86 RAS features"
+	---help---
+	A collection of Reliability, Availability and Serviceability software
+	features which enable hardware error logging and reporting.
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
index 000000000000..e69de29bb2d1
-- 
1.8.0.rc2.4.g42e55a5

