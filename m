Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2K0X3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:29:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39036 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2K0X3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:29:34 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH V7 3/7] arm64: use new common dtc rule
Date: Tue, 27 Nov 2012 16:29:12 -0700
Message-Id: <1354058956-7199-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The current rules have the .dtb files build in a different directory
from the .dts files. This patch changes arm64 to use the generic dtb
rule which builds .dtb files in the same directory as the source .dts.

This requires moving parts of arch/arm64/boot/Makefile into newly created
arch/arm64/boot/dts/Makefile, and updating arch/arm64/Makefile to call the
new Makefile.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v7: New patch.
---
 arch/arm64/Makefile          |    2 +-
 arch/arm64/boot/Makefile     |    5 -----
 arch/arm64/boot/dts/Makefile |    5 +++++
 3 files changed, 6 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/boot/dts/Makefile

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 364191f..fd3d4a1 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -54,7 +54,7 @@ zinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
 %.dtb:
-	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
 
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
diff --git a/arch/arm64/boot/Makefile b/arch/arm64/boot/Makefile
index eca209b..5a0e3ab 100644
--- a/arch/arm64/boot/Makefile
+++ b/arch/arm64/boot/Makefile
@@ -22,9 +22,6 @@ $(obj)/Image: vmlinux FORCE
 $(obj)/Image.gz: $(obj)/Image FORCE
 	$(call if_changed,gzip)
 
-$(obj)/%.dtb: $(src)/dts/%.dts
-	$(call cmd,dtc)
-
 install: $(obj)/Image
 	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
 	$(obj)/Image System.map "$(INSTALL_PATH)"
@@ -32,5 +29,3 @@ install: $(obj)/Image
 zinstall: $(obj)/Image.gz
 	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
 	$(obj)/Image.gz System.map "$(INSTALL_PATH)"
-
-clean-files += *.dtb
diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
new file mode 100644
index 0000000..801e2d7
--- /dev/null
+++ b/arch/arm64/boot/dts/Makefile
@@ -0,0 +1,5 @@
+targets += dtbs
+
+dtbs: $(addprefix $(obj)/, $(dtb-y))
+
+clean-files := *.dtb
-- 
1.7.10.4

