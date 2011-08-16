Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1HPFer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:34:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61644 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1HPFe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:34:29 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 4/4] kconfig: do not hardcode .config
Date: Tue, 16 Aug 2011 01:34:14 -0400
Message-Id: <1313472854-14426-5-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
References: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/Makefile |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index dabb4f1..a86924b 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -10,6 +10,8 @@ KCONFIG_CONFIG    ?= .config
 KCONFIG_DEFCONFIG ?=
 export KCONFIG_CONFIG
 
+dot-config := $(KCONFIG_CONFIG)
+
 xconfig: $(obj)/qconf
 	$< $(Kconfig)
 
@@ -43,14 +45,14 @@ endif
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)mkdir -p include/generated
 	$(Q)perl $< $(srctree) $(Kconfig) $(LSMOD_F) > .tmp.config
-	$(Q)if [ -f .config ]; then 					\
-			cmp -s .tmp.config .config ||			\
-			(mv -f .config .config.old.1;			\
-			 mv -f .tmp.config .config;			\
+	$(Q)if [ -f $(dot-config) ]; then 					\
+			cmp -s .tmp.config .$(dot-config) ||			\
+			(mv -f $(dot-config) $(dot-config).old.1;		\
+			 mv -f .tmp.config $(dot-config);			\
 			 $(obj)/conf --silentoldconfig $(Kconfig);	\
-			 mv -f .config.old.1 .config.old)		\
+			 mv -f $(dot-config).old.1 $(dot-config).old)	\
 	else								\
-			mv -f .tmp.config .config;			\
+			mv -f .tmp.config $(dot-config);		\
 			$(obj)/conf --silentoldconfig $(Kconfig);	\
 	fi
 	$(Q)rm -f .tmp.config
@@ -126,7 +128,7 @@ help:
 	@echo  '  menuconfig	  - Update current config utilising a menu based program'
 	@echo  '  xconfig	  - Update current config utilising a QT based front-end'
 	@echo  '  gconfig	  - Update current config utilising a GTK based front-end'
-	@echo  '  oldconfig	  - Update current config utilising a provided .config as base'
+	@echo  '  oldconfig	  - Update current config utilising a provided $(dot-config) as base'
 	@echo  '  localmodconfig  - Update current config disabling modules not loaded'
 	@echo  '  localyesconfig  - Update current config converting local mods to core'
 	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
-- 
1.7.6.153.g78432

