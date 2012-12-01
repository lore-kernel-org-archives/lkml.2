Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2LALRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:17:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42991 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2LALRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:17:52 -0500
Date: Sat, 1 Dec 2012 03:17:17 -0800
From: tip-bot for David Howells <dhowells@redhat.com>
Message-ID: <tip-tviyimq6x6nm77sj5lt4t19f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        acme@ghostprotocols.net, namhyung@gmail.com, bp@amd64.org,
        dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, acme@ghostprotocols.net, bp@amd64.org,
        namhyung@gmail.com, dhowells@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Pass the target in descend
Git-Commit-ID: 2b73f65d114b44b9bc9bd7d229f603e4cd5c1a88
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 01 Dec 2012 03:17:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b73f65d114b44b9bc9bd7d229f603e4cd5c1a88
Gitweb:     http://git.kernel.org/tip/2b73f65d114b44b9bc9bd7d229f603e4cd5c1a88
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Tue, 13 Nov 2012 14:14:38 -0300
Committer:  David Howells <dhowells@redhat.com>
CommitDate: Mon, 19 Nov 2012 22:10:36 +0000

tools: Pass the target in descend

 Fixing:

  [acme@sandy linux]$ cd tools
  [acme@sandy tools]$ make clean
      DESCEND power/cpupower
    CC       lib/cpufreq.o
    CC       lib/sysfs.o
    LD       libcpupower.so.0.0.0
    CC       utils/helpers/amd.o
  utils/helpers/amd.c:7:21: error: pci/pci.h: No such file or directory
  In file included from utils/helpers/amd.c:9:
  ./utils/helpers/helpers.h:137: warning: ‘struct pci_access’ declared inside parameter list
  ./utils/helpers/helpers.h:137: warning: its scope is only this definition or declaration, which is probably not what you want
  ./utils/helpers/helpers.h:139: warning: ‘struct pci_access’ declared inside parameter list
  utils/helpers/amd.c: In function ‘amd_pci_get_num_boost_states’:
  utils/helpers/amd.c:120: warning: passing argument 1 of ‘pci_slot_func_init’ from incompatible pointer type
  ./utils/helpers/helpers.h:138: note: expected ‘struct pci_access **’ but argument is of type ‘struct pci_access **’
  utils/helpers/amd.c:125: warning: implicit declaration of function ‘pci_read_byte’
  utils/helpers/amd.c:132: warning: implicit declaration of function ‘pci_cleanup’
  make[1]: *** [utils/helpers/amd.o] Error 1
  make: *** [cpupower_clean] Error 2
  [acme@sandy tools]$

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-tviyimq6x6nm77sj5lt4t19f@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/scripts/Makefile.include | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 87467b1..2964b96 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -51,7 +51,7 @@ endif
 #
 descend = \
 	+mkdir -p $(OUTPUT)$(1) && \
-	$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1)
+	$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
 
 QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
@@ -72,6 +72,6 @@ ifndef V
 	descend = \
 		@echo '   ' DESCEND $(1); \
 		mkdir -p $(OUTPUT)$(1) && \
-		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1)
+		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
 endif
 endif
