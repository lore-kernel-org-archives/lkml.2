Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837Ab2GFKmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:42:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38261 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810Ab2GFKmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:42:40 -0400
From: Antonio Meireles <antonio.meireles@openfiler.com>
To: linux-kernel@vger.kernel.org
Cc: len.brown@intel.com, Antonio Meireles <antonio.meireles@openfiler.com>
Subject: [PATCH] tools/power x86: Makefile fixes
Date: Fri,  6 Jul 2012 11:42:24 +0100
Message-Id: <1341571344-25408-1-git-send-email-antonio.meireles@openfiler.com>
X-Mailer: git-send-email 1.7.10.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Make the install relative to DESTDIR if specified.
	Honor, as well, custom installation settings, if they are present.

	Signed-off-by: Antonio Meireles <antonio.meireles@openfiler.com>
---
 tools/power/x86/turbostat/Makefile              |   24 +++++++++++++++++++----
 tools/power/x86/x86_energy_perf_policy/Makefile |   24 +++++++++++++++++++----
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index fd8e1f1..8b1c430 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -1,8 +1,24 @@
-turbostat : turbostat.c
+OUTPUT=./
+ifeq ("$(origin O)", "command line")
+       OUTPUT := $(O)/
+endif
+
+DESTDIR ?=
+
+bindir ?= /usr/bin
+mandir ?= /usr/man
+
+INSTALL = /usr/bin/install -c
+INSTALL_PROGRAM = ${INSTALL}
+INSTALL_DATA  = ${INSTALL} -m 644
+
+$(OUTPUT)turbostat : turbostat.c
 
 clean :
-	rm -f turbostat
+	rm -f $(OUTPUT)turbostat
 
 install :
-	install turbostat /usr/bin/turbostat
-	install turbostat.8 /usr/share/man/man8
+	$(INSTALL) -d $(DESTDIR)${bindir}
+	$(INSTALL) -d $(DESTDIR)${mandir}/man8
+	$(INSTALL_PROGRAM) $(OUTPUT)turbostat $(DESTDIR)${bindir}/
+	$(INSTALL_DATA) turbostat.8 $(DESTDIR)${mandir}/man8/
diff --git a/tools/power/x86/x86_energy_perf_policy/Makefile b/tools/power/x86/x86_energy_perf_policy/Makefile
index f458237..c20971d 100644
--- a/tools/power/x86/x86_energy_perf_policy/Makefile
+++ b/tools/power/x86/x86_energy_perf_policy/Makefile
@@ -1,8 +1,24 @@
-x86_energy_perf_policy : x86_energy_perf_policy.c
+OUTPUT=./
+ifeq ("$(origin O)", "command line")
+       OUTPUT := $(O)/
+endif
+
+DESTDIR ?=
+
+bindir ?= /usr/bin
+mandir ?= /usr/man
+
+INSTALL = /usr/bin/install -c
+INSTALL_PROGRAM = ${INSTALL}
+INSTALL_DATA  = ${INSTALL} -m 644
+
+$(OUTPUT)x86_energy_perf_policy : x86_energy_perf_policy.c
 
 clean :
-	rm -f x86_energy_perf_policy
+	rm -f $(OUTPUT)x86_energy_perf_policy
 
 install :
-	install x86_energy_perf_policy /usr/bin/
-	install x86_energy_perf_policy.8 /usr/share/man/man8/
+	$(INSTALL) -d $(DESTDIR)${bindir}
+	$(INSTALL) -d $(DESTDIR)${mandir}/man8
+	$(INSTALL_PROGRAM) $(OUTPUT)x86_energy_perf_policy $(DESTDIR)${bindir}/
+	$(INSTALL_DATA) x86_energy_perf_policy.8 $(DESTDIR)${mandir}/man8/
-- 
1.7.10.2

