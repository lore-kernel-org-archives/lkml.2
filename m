Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1KELVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 07:21:51 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:50452 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab1KELVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 07:21:49 -0400
Subject: [PATCH] kconfig: adapt update-po-config to new UML layout
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: Richard Weinberger <richard@nod.at>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Foley <pefoley2@verizon.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Nov 2011 12:21:30 +0100
Message-ID: <1320492090.14409.321.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5c48b108 ("um: take arch/um/sys-x86 to arch/x86/um") broke the
make target update-po-config, as its symlink trick (again) fails.
(Previous breakage was fixed with commit bdc69ca4 ("kconfig: change
update-po-config to reflect new layout of arch/um").)

The new UML layout allows to drop the symlick trick entirely. And if,
one day, another architecture supports UML too, that should now work
without again breaking this make target.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I've decided to only fix the breakage and not also the warning "make
update-po-config" triggers (see the discussion starting at
https://lkml.org/lkml/2011/11/3/336 ). That's apparently nothing new and
fixing it requires some more discussion. At least it's no clear to me
what the best solution is. And it could even be fixed by changes to the
main Makefile.

1) A similar proposal (for the previous layout) by Peter Foley was
https://lkml.org/lkml/2011/10/22/158 . Did it got dropped?

 scripts/kconfig/Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 82d2eb2..0b0fc70 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -84,8 +84,8 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    --directory=$(srctree) --directory=$(objtree)           \
 	    --output $(obj)/config.pot
 	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
-	$(Q)ln -fs Kconfig.x86 arch/um/Kconfig
-	$(Q)(for i in `ls $(srctree)/arch/*/Kconfig`;    \
+	$(Q)(for i in `ls $(srctree)/arch/*/Kconfig      \
+	    $(srctree)/arch/*/um/Kconfig`;               \
 	    do                                           \
 		echo "  GEN $$i";                        \
 		$(obj)/kxgettext $$i                     \
@@ -93,7 +93,6 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    done )
 	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
 	    --output $(obj)/linux.pot
-	$(Q)rm -f $(srctree)/arch/um/Kconfig
 	$(Q)rm -f $(obj)/config.pot
 
 PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
-- 
1.7.4.4

