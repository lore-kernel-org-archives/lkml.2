Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0LMA0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:26:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44780 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab0LLXph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:37 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tmb@mandriva.org, monstr@monstr.eu, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [39/223] microblaze: Fix build with make 3.82
Message-Id: <20101212234535.E156AB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Backlund <tmb@mandriva.org>

commit b843e4ec01991a386a9e0e9030703524446e03da upstream.

When running make headers_install_all on x86_64 and make 3.82 I hit this:

arch/microblaze/Makefile:80: *** mixed implicit and normal rules.  Stop.
make: *** [headers_install_all] Error 2

So split the rules to satisfy make 3.82.

Signed-off-by: Thomas Backlund <tmb@mandriva.org>
Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/microblaze/Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/arch/microblaze/Makefile
===================================================================
--- linux.orig/arch/microblaze/Makefile
+++ linux/arch/microblaze/Makefile
@@ -72,12 +72,16 @@ export MMU DTB
 
 all: linux.bin
 
-BOOT_TARGETS = linux.bin linux.bin.gz simpleImage.%
+# With make 3.82 we cannot mix normal and wildcard targets
+BOOT_TARGETS1 = linux.bin linux.bin.gz
+BOOT_TARGETS2 = simpleImage.%
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
-$(BOOT_TARGETS): vmlinux
+$(BOOT_TARGETS1): vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+$(BOOT_TARGETS2): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
 define archhelp
