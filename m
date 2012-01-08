Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2AHVQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 16:16:34 -0500
Received: from ip-213-220-200-171.net.upcbroadband.cz ([213.220.200.171]:61717
	"EHLO emu.suse.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754492Ab2AHVQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 16:16:33 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jan 2012 16:16:33 EST
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Fix comment in Makefile.lib
Date: Sun,  8 Jan 2012 22:08:05 +0100
Message-Id: <1326056885-6226-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KBUILD_MODNAME is not defined for files that are linked into multiple
modules, and trying to change reality to match documentation would
result in all sorts of trouble. E.g. options for built-in modules would
be called either foo_bar.param, foo.param, or bar.param, depending on
the configuration. So just change the comment.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Makefile.lib |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 5d986d9..2ce2e21 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -93,9 +93,9 @@ obj-dirs	:= $(addprefix $(obj)/,$(obj-dirs))
 # already
 # $(modname_flags) #defines KBUILD_MODNAME as the name of the module it will 
 # end up in (or would, if it gets compiled in)
-# Note: It's possible that one object gets potentially linked into more
-#       than one module. In that case KBUILD_MODNAME will be set to foo_bar,
-#       where foo and bar are the name of the modules.
+# Note: Files that end up in two or more modules are compiled without the
+#       KBUILD_MODNAME definition. The reason is that any made-up name would
+#       differ in different configs.
 name-fix = $(subst $(comma),_,$(subst -,_,$1))
 basename_flags = -D"KBUILD_BASENAME=KBUILD_STR($(call name-fix,$(basetarget)))"
 modname_flags  = $(if $(filter 1,$(words $(modname))),\
-- 
1.7.7

