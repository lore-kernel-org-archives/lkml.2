Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab1DNSdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:33:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:37507 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab1DNRpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Thomas Backlund <tmb@mandriva.org>,
        Michal Simek <monstr@monstr.eu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 023/209] microblaze: Fix build with make 3.82
Date: Thu, 14 Apr 2011 13:40:53 -0400
Message-Id: <1302803039-9400-24-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Backlund <tmb@mandriva.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit b843e4ec01991a386a9e0e9030703524446e03da upstream.

When running make headers_install_all on x86_64 and make 3.82 I hit this:

arch/microblaze/Makefile:80: *** mixed implicit and normal rules.  Stop.
make: *** [headers_install_all] Error 2

So split the rules to satisfy make 3.82.

Signed-off-by: Thomas Backlund <tmb@mandriva.org>
Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/microblaze/Makefile |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index 72f6e85..45e6afc 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
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
-- 
1.7.4.4

