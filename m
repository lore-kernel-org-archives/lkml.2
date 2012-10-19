Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015Ab2JSCtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:52381 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964974Ab2JSCtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <JBeulich@suse.com>, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 53/76] kbuild: Fix accidental revert in commit fe04ddf
Date: Thu, 18 Oct 2012 19:47:17 -0700
Message-Id: <20121019024358.644412596@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Marek <mmarek@suse.cz>

commit 3ce9e53e788881da0d5f3912f80e0dd6b501f304 upstream.

Commit fe04ddf7c291 ("kbuild: Do not package /boot and /lib in make
tar-pkg") accidentally reverted two previous kbuild commits.  I don't
know what I was thinking.

This brings back changes made by commits 24cc7fb69a5b ("x86/kbuild:
archscripts depends on scripts_basic") and c1c1a59e37da ("firmware: fix
directory creation rule matching with make 3.80")

Reported-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Makefile       |    2 +-
 scripts/Makefile.fwinst |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -142,7 +142,7 @@ KBUILD_CFLAGS += $(call cc-option,-mno-a
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
-archscripts:
+archscripts: scripts_basic
 	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
 
 ###
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -27,7 +27,7 @@ endif
 installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
 
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
-installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/.
+installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/./
 
 # Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
 PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs
@@ -42,7 +42,7 @@ quiet_cmd_install = INSTALL $(subst $(sr
 $(installed-fw-dirs):
 	$(call cmd,mkdir)
 
-$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $$(dir $(INSTALL_FW_PATH)/%)
+$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)
 	$(call cmd,install)
 
 PHONY +=  __fw_install __fw_modinst FORCE


