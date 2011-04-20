Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1DTTWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:22:45 -0400
Received: from host6.netdorm.com ([64.182.105.6]:49469 "EHLO host6.netdorm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab1DTTWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:22:43 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DAF2720.1060906@verizon.net>
Date: Wed, 20 Apr 2011 14:34:08 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, <mmarek@suse.cz>
Subject: [PATCH 1/2] kbuild: move scripts/basic/docproc.c to scripts/docproc.c
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Foley <pefoley2@verizon.net>

Move docproc from scripts/basic to scripts so it is only built for *doc targets
instead of every time the kernel is built.

Signed-off-by: Peter Foley <pefoley2@verizon.net>

---
 Documentation/DocBook/Makefile |    2 +-
 Makefile                       |    1 +
 scripts/.gitignore             |    1 +
 scripts/Makefile               |   11 +++++++----
 scripts/basic/.gitignore       |    2 --
 scripts/basic/Makefile         |    3 +--
 scripts/{basic => }/docproc.c  |    0
 7 files changed, 11 insertions(+), 9 deletions(-)
 rename scripts/{basic => }/docproc.c (100%)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 8436b01..3cebfa0 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -73,7 +73,7 @@ installmandocs: mandocs
 ###
 #External programs used
 KERNELDOC = $(srctree)/scripts/kernel-doc
-DOCPROC   = $(objtree)/scripts/basic/docproc
+DOCPROC   = $(objtree)/scripts/docproc
  XMLTOFLAGS = -m $(srctree)/Documentation/DocBook/stylesheet.xsl
 XMLTOFLAGS += --skip-validation
diff --git a/Makefile b/Makefile
index b967b96..44d49a9 100644
--- a/Makefile
+++ b/Makefile
@@ -1290,6 +1290,7 @@ $(help-board-dirs): help-%:
 # Documentation targets
 # ---------------------------------------------------------------------------
 %docs: scripts_basic FORCE
+	$(Q)$(MAKE) $(build)=scripts build_docproc
 	$(Q)$(MAKE) $(build)=Documentation/DocBook $@
  else # KBUILD_EXTMOD
diff --git a/scripts/.gitignore b/scripts/.gitignore
index e2741d2..105b21f 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -8,3 +8,4 @@ bin2c
 unifdef
 ihex2fw
 recordmcount
+docproc
diff --git a/scripts/Makefile b/scripts/Makefile
index fcea261..31a450c 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -5,7 +5,8 @@
 # kallsyms:      Find all symbols in vmlinux
 # pnmttologo:    Convert pnm files to logo files
 # conmakehash:   Create chartable
-# conmakehash:	 Create arrays for initializing the kernel console tables
+# conmakehash:   Create arrays for initializing the kernel console tables
+# docproc:       Used in Documentation/DocBook
  hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
@@ -16,12 +17,14 @@ hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 always		:= $(hostprogs-y) $(hostprogs-m)
  # The following hostprogs-y programs are only build on demand
-hostprogs-y += unifdef
+hostprogs-y += unifdef docproc
 -# This target is used internally to avoid "is up to date" messages
-PHONY += build_unifdef
+# These targets are used internally to avoid "is up to date" messages
+PHONY += build_unifdef build_docproc
 build_unifdef: scripts/unifdef FORCE
 	@:
+build_docproc: scripts/docproc FORCE
+	@:
  subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
diff --git a/scripts/basic/.gitignore b/scripts/basic/.gitignore
index bf8b199..a776371 100644
--- a/scripts/basic/.gitignore
+++ b/scripts/basic/.gitignore
@@ -1,3 +1 @@
-hash
 fixdep
-docproc
diff --git a/scripts/basic/Makefile b/scripts/basic/Makefile
index 4c324a1..4fcef87 100644
--- a/scripts/basic/Makefile
+++ b/scripts/basic/Makefile
@@ -7,9 +7,8 @@
 # .config is included by main Makefile.
 # ---------------------------------------------------------------------------
 # fixdep: 	 Used to generate dependency information during build process
-# docproc:	 Used in Documentation/DocBook
 -hostprogs-y	:= fixdep docproc
+hostprogs-y	:= fixdep
 always		:= $(hostprogs-y)
  # fixdep is needed to compile other host programs
diff --git a/scripts/basic/docproc.c b/scripts/docproc.c
similarity index 100%
rename from scripts/basic/docproc.c
rename to scripts/docproc.c
-- 
1.7.5.rc1


