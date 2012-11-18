Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2KROdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:33:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36581 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab2KROaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 30/32] tools: Pass the target in descend
Date: Sun, 18 Nov 2012 11:29:55 -0300
Message-Id: <1353248997-30763-31-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

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
 tools/scripts/Makefile.include |    4 ++--
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
-- 
1.7.9.2.358.g22243

