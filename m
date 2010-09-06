Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0IFLtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:49:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab0IFLtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:49:04 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kbuild: Use a single clean rule for kernel and external modules
Date: Mon,  6 Sep 2010 13:48:16 +0200
Message-Id: <1283773696-3911-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283773696-3911-1-git-send-email-mmarek@suse.cz>
References: <1283773696-3911-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list of patterns for the external modules case was constantly
lagging behind.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/Makefile b/Makefile
index d71bfde..414a646 100644
--- a/Makefile
+++ b/Makefile
@@ -1186,15 +1186,7 @@ PHONY += $(clean-dirs) clean archclean
 $(clean-dirs):
 	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
 
-clean: archclean $(clean-dirs)
-	$(call cmd,rmdirs)
-	$(call cmd,rmfiles)
-	@find . $(RCS_FIND_IGNORE) \
-		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
-		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' -o -name 'modules.order' \
-		-o -name modules.builtin -o -name '.tmp_*.o.*' \
-		-o -name '*.gcno' \) -type f -print | xargs rm -f
+clean: archclean
 
 # mrproper - Delete all generated files, including .config
 #
@@ -1392,16 +1384,7 @@ $(clean-dirs):
 	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
 
 clean:	rm-dirs := $(MODVERDIR)
-clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers \
-                   $(KBUILD_EXTMOD)/modules.order \
-                   $(KBUILD_EXTMOD)/modules.builtin
-clean: $(clean-dirs)
-	$(call cmd,rmdirs)
-	$(call cmd,rmfiles)
-	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
-		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
-		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.gcno' \) -type f -print | xargs rm -f
+clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers
 
 help:
 	@echo  '  Building external modules.'
@@ -1418,6 +1401,16 @@ prepare: ;
 scripts: ;
 endif # KBUILD_EXTMOD
 
+clean: $(clean-dirs)
+	$(call cmd,rmdirs)
+	$(call cmd,rmfiles)
+	@find $(or $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
+		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
+		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
+		-o -name '*.symtypes' -o -name 'modules.order' \
+		-o -name modules.builtin -o -name '.tmp_*.o.*' \
+		-o -name '*.gcno' \) -type f -print | xargs rm -f
+
 # Generate tags for editors
 # ---------------------------------------------------------------------------
 quiet_cmd_tags = GEN     $@
-- 
1.7.1

