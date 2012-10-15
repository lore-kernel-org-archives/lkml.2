Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2JOTRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:17:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab2JOTRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:17:12 -0400
From: Michal Marek <mmarek@suse.cz>
To: torvalds@linux-foundation.org, JBeulich@suse.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Fix accidental revert in commit fe04ddf
Date: Mon, 15 Oct 2012 21:16:56 +0200
Message-Id: <1350328616-4486-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <507C475502000078000A17AA@nat28.tlf.novell.com>
References: <507C475502000078000A17AA@nat28.tlf.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fe04ddf (kbuild: Do not package /boot and /lib in make tar-pkg)
accidentally reverted two previous kbuild commits. I don't know what I
was thinking. This patch brings back changes made by
24cc7fb (x86/kbuild: archscripts depends on scripts_basic)
c1c1a59 (firmware: fix directory creation rule matching with make 3.80)

Reported-by: Jan Beulich <JBeulich@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/x86/Makefile       |    2 +-
 scripts/Makefile.fwinst |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 58790bd..05afcca 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -142,7 +142,7 @@ KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
-archscripts:
+archscripts: scripts_basic
 	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
 
 ###
diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index c3f69ae..4d908d1 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -27,7 +27,7 @@ endif
 installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
 
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
-installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/.
+installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/./
 
 # Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
 PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs
@@ -42,7 +42,7 @@ quiet_cmd_install = INSTALL $(subst $(srctree)/,,$@)
 $(installed-fw-dirs):
 	$(call cmd,mkdir)
 
-$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $$(dir $(INSTALL_FW_PATH)/%)
+$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)
 	$(call cmd,install)
 
 PHONY +=  __fw_install __fw_modinst FORCE
-- 
1.7.10.4

