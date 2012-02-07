Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2BGQQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:16:13 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35991 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2BGQQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:16:10 -0500
From: Franck Bui-Huu <fbuihuu@gmail.com>
To: linux@dominikbrodowski.net
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>
Subject: [PATCH 2/2] cpupower tools: add install target to the debug tools' makefiles
Date: Tue,  7 Feb 2012 17:15:57 +0100
Message-Id: <1328631357-18463-2-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1328631357-18463-1-git-send-email-fbuihuu@gmail.com>
References: <1328631357-18463-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/power/cpupower/debug/i386/Makefile   |   14 +++++++++++++-
 tools/power/cpupower/debug/x86_64/Makefile |   12 +++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/debug/i386/Makefile b/tools/power/cpupower/debug/i386/Makefile
index 626478b..3ba158f 100644
--- a/tools/power/cpupower/debug/i386/Makefile
+++ b/tools/power/cpupower/debug/i386/Makefile
@@ -3,6 +3,11 @@ ifeq ("$(origin O)", "command line")
 	OUTPUT := $(O)/
 endif
 
+DESTDIR =
+bindir  = /usr/bin
+
+INSTALL = /usr/bin/install
+
 
 default: all
 
@@ -23,4 +28,11 @@ all: $(OUTPUT)centrino-decode $(OUTPUT)dump_psb $(OUTPUT)intel_gsic $(OUTPUT)pow
 clean:
 	rm -rf $(OUTPUT){centrino-decode,dump_psb,intel_gsic,powernow-k8-decode}
 
-.PHONY: all default clean
+install:
+	$(INSTALL) -d $(DESTDIR)${bindir}
+	$(INSTALL) $(OUTPUT)centrino-decode $(DESTDIR)${bindir}
+	$(INSTALL) $(OUTPUT)powernow-k8-decode $(DESTDIR)${bindir}
+	$(INSTALL) $(OUTPUT)dump_psb $(DESTDIR)${bindir}
+	$(INSTALL) $(OUTPUT)intel_gsic $(DESTDIR)${bindir}
+
+.PHONY: all default clean install
diff --git a/tools/power/cpupower/debug/x86_64/Makefile b/tools/power/cpupower/debug/x86_64/Makefile
index 8e26d67..1c52145 100644
--- a/tools/power/cpupower/debug/x86_64/Makefile
+++ b/tools/power/cpupower/debug/x86_64/Makefile
@@ -3,6 +3,11 @@ ifeq ("$(origin O)", "command line")
 	OUTPUT := $(O)/
 endif
 
+DESTDIR =
+bindir  = /usr/bin
+
+INSTALL = /usr/bin/install
+
 
 default: all
 
@@ -17,4 +22,9 @@ all: $(OUTPUT)centrino-decode $(OUTPUT)powernow-k8-decode
 clean:
 	rm -rf $(OUTPUT)centrino-decode $(OUTPUT)powernow-k8-decode
 
-.PHONY: all default clean
+install:
+	$(INSTALL) -d $(DESTDIR)${bindir}
+	$(INSTALL) $(OUTPUT)centrino-decode $(DESTDIR)${bindir}
+	$(INSTALL) $(OUTPUT)powernow-k8-decode $(DESTDIR)${bindir}
+
+.PHONY: all default clean install
-- 
1.7.7.4

