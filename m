Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab2GTV7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:59:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2GTV66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:58:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/13] UAPI: Remove the objhdr-y export list
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Date: Fri, 20 Jul 2012 22:58:42 +0100
Message-ID: <20120720215842.14854.34363.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the objhdr-y export list as it is no longer used.  genhdr-y should be
used instead.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/kbuild/makefiles.txt |    8 ++++----
 scripts/Makefile.headersinst       |    7 ++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index ab0a984..ec9ae67 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -45,7 +45,7 @@ This document describes the Linux kernel Makefiles.
 
 	=== 7 Kbuild syntax for exported headers
 		--- 7.1 header-y
-		--- 7.2 objhdr-y
+		--- 7.2 genhdr-y
 		--- 7.3 destination-y
 		--- 7.4 generic-y
 
@@ -1282,15 +1282,15 @@ See subsequent chapter for the syntax of the Kbuild file.
 
 	Subdirectories are visited before their parent directories.
 
-	--- 7.2 objhdr-y
+	--- 7.2 genhdr-y
 
-	objhdr-y specifies generated files to be exported.
+	genhdr-y specifies generated files to be exported.
 	Generated files are special as they need to be looked
 	up in another directory when doing 'make O=...' builds.
 
 		Example:
 			#include/linux/Kbuild
-			objhdr-y += version.h
+			genhdr-y += version.h
 
 	--- 7.3 destination-y
 
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index d3bae5e..463b95a 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -3,8 +3,7 @@
 #
 # header-y  - list files to be installed. They are preprocessed
 #             to remove __KERNEL__ section of the file
-# objhdr-y  - Same as header-y but for generated files
-# genhdr-y  - Same as objhdr-y but in a generated/ directory
+# genhdr-y  - Same as header-y but in a generated/ directory
 #
 # ==========================================================================
 
@@ -37,9 +36,8 @@ wrapper-files := $(filter $(header-y), $(generic-y))
 
 # all headers files for this dir
 header-y      := $(filter-out $(generic-y), $(header-y))
-all-files     := $(header-y) $(objhdr-y) $(genhdr-y) $(wrapper-files)
+all-files     := $(header-y) $(genhdr-y) $(wrapper-files)
 input-files   := $(addprefix $(srctree)/$(obj)/,$(header-y)) \
-                 $(addprefix $(objtree)/$(obj)/,$(objhdr-y)) \
                  $(addprefix $(objtree)/$(gen)/,$(genhdr-y))
 output-files  := $(addprefix $(install)/, $(all-files))
 
@@ -56,7 +54,6 @@ quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
                             file$(if $(word 2, $(all-files)),s))
       cmd_install = \
         $(PERL) $< $(srctree)/$(obj) $(install) $(SRCARCH) $(header-y); \
-        $(PERL) $< $(objtree)/$(obj) $(install) $(SRCARCH) $(objhdr-y); \
         $(PERL) $< $(objtree)/$(gen) $(install) $(SRCARCH) $(genhdr-y); \
         for F in $(wrapper-files); do                                   \
                 echo "\#include <asm-generic/$$F>" > $(install)/$$F;    \

