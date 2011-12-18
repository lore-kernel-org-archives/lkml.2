Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1LRXUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:20:24 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:37808 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1LRXUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:20:22 -0500
Date: Sun, 18 Dec 2011 18:15:16 -0500 (EST)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH] Improve update-po-config output
Message-id: <alpine.LNX.2.00.1112181809470.20582@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make the V=0 output from update-po-config be aligned correctly.
Also remove an outdated comment and add a "GEN" statement. 

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 914833d..7966265 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -50,9 +50,8 @@ localyesconfig localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
-# The symlink is used to repair a deficiency in arch/um
 update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
-	$(Q)echo "  GEN config"
+	$(Q)echo "  GEN     config.pot"
 	$(Q)xgettext --default-domain=linux                         \
 	    --add-comments --keyword=_ --keyword=N_                 \
 	    --from-code=UTF-8                                       \
@@ -63,10 +62,11 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	$(Q)(for i in `ls $(srctree)/arch/*/Kconfig      \
 	    $(srctree)/arch/*/um/Kconfig`;               \
 	    do                                           \
-		echo "  GEN $$i";                        \
+		echo "  GEN     $$i";                    \
 		$(obj)/kxgettext $$i                     \
 		     >> $(obj)/config.pot;               \
 	    done )
+	$(Q)echo "  GEN     linux.pot"
 	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
 	    --output $(obj)/linux.pot
 	$(Q)rm -f $(obj)/config.pot
-- 
1.7.8

