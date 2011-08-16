Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1HPFec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:34:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47112 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1HPFe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:34:28 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 3/4] kbuild: do not hardcode .config
Date: Tue, 16 Aug 2011 01:34:13 -0400
Message-Id: <1313472854-14426-4-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
References: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index e7b576e..c36195a 100644
--- a/Makefile
+++ b/Makefile
@@ -973,7 +973,7 @@ PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
 prepare3: include/config/kernel.release
 ifneq ($(KBUILD_SRC),)
 	@$(kecho) '  Using $(srctree) as source for kernel'
-	$(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
+	$(Q)if [ -f $(srctree)/$(KBUILD_CONFIG) -o -d $(srctree)/include/config ]; then \
 		echo "  $(srctree) is not clean, please run 'make mrproper'";\
 		echo "  in the '$(srctree)' directory.";\
 		/bin/false; \
@@ -1168,7 +1168,7 @@ CLEAN_FILES +=	vmlinux System.map \
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config usr/include include/generated          \
                   arch/*/include/generated
-MRPROPER_FILES += .config .config.old .version .old_version             \
+MRPROPER_FILES += $(KBUILD_CONFIG) $(KBUILD_CONFIG).old .version .old_version \
                   include/linux/version.h                               \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
 
@@ -1295,7 +1295,7 @@ help:
 
 	@echo  '  make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build'
 	@echo  '  make V=2   [targets] 2 => give reason for rebuild of target'
-	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
+	@echo  '  make O=dir [targets] Locate all output files in "dir", including $(KBUILD_CONFIG)'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
 	@echo  '  make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections'
-- 
1.7.6.153.g78432

