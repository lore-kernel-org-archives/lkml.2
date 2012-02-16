Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2BPVs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:48:26 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26437 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2BPVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:48:24 -0500
Date: Thu, 16 Feb 2012 22:49:15 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kbuild@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        trivial@kernel.org
Subject: [PATCH][Trivial] Makefile: Break a few overlong lines and adjust
 placement of a few line continuations
Message-ID: <alpine.LNX.2.00.1202162247300.25384@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break a few lines that go way over the usual 80 column limit that we prefer.
Also adjust the placement of a few line continuations.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 Makefile |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 7c44b67..da01a71 100644
--- a/Makefile
+++ b/Makefile
@@ -400,8 +400,10 @@ export MODVERDIR := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/).tmp_ve
 
 # Files to ignore in find ... statements
 
-RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS -o -name .pc -o -name .hg -o -name .git \) -prune -o
-export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn --exclude CVS --exclude .pc --exclude .hg --exclude .git
+RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS \
+		   -o -name .pc -o -name .hg -o -name .git \) -prune -o
+export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn \
+			 --exclude CVS --exclude .pc --exclude .hg --exclude .git
 
 # ===========================================================================
 # Rules shared between *config targets and build targets
@@ -966,7 +968,7 @@ prepare3: include/config/kernel.release
 ifneq ($(KBUILD_SRC),)
 	@$(kecho) '  Using $(srctree) as source for kernel'
 	$(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
-		echo "  $(srctree) is not clean, please run 'make mrproper'";\
+		echo "  $(srctree) is not clean, please run 'make mrproper'"; \
 		echo "  in the '$(srctree)' directory.";\
 		/bin/false; \
 	fi;
@@ -1003,8 +1005,8 @@ define filechk_utsrelease.h
 endef
 
 define filechk_version.h
-	(echo \#define LINUX_VERSION_CODE $(shell                             \
-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL));    \
+	(echo \#define LINUX_VERSION_CODE $(shell                         \
+	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 
-- 
1.7.9.1



PS. Please CC me on replies.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

