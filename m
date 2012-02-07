Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2BGQQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:16:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47762 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2BGQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:16:06 -0500
From: Franck Bui-Huu <fbuihuu@gmail.com>
To: linux@dominikbrodowski.net
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>
Subject: [PATCH 1/2] cpupower tools: allow to build debug tools in a separate directory too
Date: Tue,  7 Feb 2012 17:15:56 +0100
Message-Id: <1328631357-18463-1-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/power/cpupower/debug/i386/Makefile   |   26 ++++++++++++++++----------
 tools/power/cpupower/debug/x86_64/Makefile |   14 ++++++++++----
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/tools/power/cpupower/debug/i386/Makefile b/tools/power/cpupower/debug/i386/Makefile
index d08cc1e..626478b 100644
--- a/tools/power/cpupower/debug/i386/Makefile
+++ b/tools/power/cpupower/debug/i386/Makefile
@@ -1,20 +1,26 @@
+OUTPUT=./
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+endif
+
+
 default: all
 
-centrino-decode: centrino-decode.c
-	$(CC) $(CFLAGS) -o centrino-decode centrino-decode.c
+$(OUTPUT)centrino-decode: centrino-decode.c
+	$(CC) $(CFLAGS) -o $@ centrino-decode.c
 
-dump_psb: dump_psb.c
-	$(CC) $(CFLAGS) -o dump_psb dump_psb.c
+$(OUTPUT)dump_psb: dump_psb.c
+	$(CC) $(CFLAGS) -o $@ dump_psb.c
 
-intel_gsic: intel_gsic.c
-	$(CC) $(CFLAGS) -o intel_gsic -llrmi intel_gsic.c
+$(OUTPUT)intel_gsic: intel_gsic.c
+	$(CC) $(CFLAGS) -o $@ -llrmi intel_gsic.c
 
-powernow-k8-decode: powernow-k8-decode.c
-	$(CC) $(CFLAGS) -o powernow-k8-decode powernow-k8-decode.c
+$(OUTPUT)powernow-k8-decode: powernow-k8-decode.c
+	$(CC) $(CFLAGS) -o $@ powernow-k8-decode.c
 
-all: centrino-decode dump_psb intel_gsic powernow-k8-decode
+all: $(OUTPUT)centrino-decode $(OUTPUT)dump_psb $(OUTPUT)intel_gsic $(OUTPUT)powernow-k8-decode
 
 clean:
-	rm -rf centrino-decode dump_psb intel_gsic powernow-k8-decode
+	rm -rf $(OUTPUT){centrino-decode,dump_psb,intel_gsic,powernow-k8-decode}
 
 .PHONY: all default clean
diff --git a/tools/power/cpupower/debug/x86_64/Makefile b/tools/power/cpupower/debug/x86_64/Makefile
index 3326217..8e26d67 100644
--- a/tools/power/cpupower/debug/x86_64/Makefile
+++ b/tools/power/cpupower/debug/x86_64/Makefile
@@ -1,14 +1,20 @@
+OUTPUT=./
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+endif
+
+
 default: all
 
-centrino-decode: ../i386/centrino-decode.c
+$(OUTPUT)centrino-decode: ../i386/centrino-decode.c
 	$(CC) $(CFLAGS) -o $@ $<
 
-powernow-k8-decode: ../i386/powernow-k8-decode.c
+$(OUTPUT)powernow-k8-decode: ../i386/powernow-k8-decode.c
 	$(CC) $(CFLAGS) -o $@ $<
 
-all: centrino-decode powernow-k8-decode
+all: $(OUTPUT)centrino-decode $(OUTPUT)powernow-k8-decode
 
 clean:
-	rm -rf centrino-decode powernow-k8-decode
+	rm -rf $(OUTPUT)centrino-decode $(OUTPUT)powernow-k8-decode
 
 .PHONY: all default clean
-- 
1.7.7.4

