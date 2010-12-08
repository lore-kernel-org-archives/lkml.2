Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab0LHCTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:19:54 -0500
Received: from kroah.org ([198.145.64.141]:45858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab0LHAqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:35 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:25 2010
Message-Id: <20101208004425.288141982@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Backlund <tmb@mandriva.org>, Michal Simek <monstr@monstr.eu>
Subject: [009/127] microblaze: Fix build with make 3.82
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 arch/microblaze/Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -69,12 +69,16 @@ export MMU DTB
 
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


