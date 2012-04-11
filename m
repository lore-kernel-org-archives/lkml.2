Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302Ab2DKVFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:05:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49840 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761242Ab2DKVFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:05:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/13] tools: Connect to the kernel build system
Date: Wed, 11 Apr 2012 18:05:18 -0300
Message-Id: <1334178325-19148-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334178325-19148-1-git-send-email-acme@infradead.org>
References: <1334178325-19148-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Now you can do

$ make tools/<toolname>

from the toplevel kernel directory and have the respective tool built.

If you want to build and install it, do

$ make tools/<toolname>_install

$ make tools/<toolname>_clean

should clean the respective tool directories.

If you want to clean all in tools, simply do

$ make tools/clean

Also, if you want to get what the possible targets are, simply calling

$ make tools/

should give you the short help.

$ make tools/install

installs all tools, of course. Doh.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/1334162178-17152-6-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Makefile       |    7 +++++++
 tools/Makefile |   10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Makefile b/Makefile
index 1932984..23b9ce5 100644
--- a/Makefile
+++ b/Makefile
@@ -1468,6 +1468,13 @@ kernelrelease:
 kernelversion:
 	@echo $(KERNELVERSION)
 
+# Clear a bunch of variables before executing the submake
+tools/: FORCE
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
+
+tools/%: FORCE
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
+
 # Single targets
 # ---------------------------------------------------------------------------
 # Single targets are compatible with:
diff --git a/tools/Makefile b/tools/Makefile
index f87c0ec..3ae4394 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -14,6 +14,16 @@ help:
 	@echo '  vm         - misc vm tools'
 	@echo '  x86_energy_perf_policy - Intel energy policy tool'
 	@echo ''
+	@echo 'You can do:'
+	@echo ' $$ make -C tools/<tool>_install'
+	@echo ''
+	@echo '  from the kernel command line to build and install one of'
+	@echo '  the tools above'
+	@echo ''
+	@echo '  $$ make tools/install'
+	@echo ''
+	@echo '  installs all tools.'
+	@echo ''
 	@echo 'Cleaning targets:'
 	@echo ''
 	@echo '  all of the above with the "_clean" string appended cleans'
-- 
1.7.9.2.358.g22243

