Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab2HGCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:25:28 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64210 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab2HGCZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:25:22 -0400
From: Palmer Cox <p@lmercox.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, Palmer Cox <p@lmercox.com>
Subject: [PATCH 1/6] cpupower tools: Remove brace expansion from clean target
Date: Mon,  6 Aug 2012 22:24:43 -0400
Message-Id: <1344306288-12369-2-git-send-email-p@lmercox.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344306288-12369-1-git-send-email-p@lmercox.com>
References: <1344306288-12369-1-git-send-email-p@lmercox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clean targets from the cpupower tools' Makefiles use brace expansion to
remove some generated files. However, the default shells on many systems do
not support this feature resulting in some generated files not being removed
by clean.
---
 tools/power/cpupower/Makefile            |    3 ++-
 tools/power/cpupower/debug/i386/Makefile |    5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/Makefile b/tools/power/cpupower/Makefile
index a93e06c..44b7a06 100644
--- a/tools/power/cpupower/Makefile
+++ b/tools/power/cpupower/Makefile
@@ -253,7 +253,8 @@ clean:
 	 | xargs rm -f
 	-rm -f $(OUTPUT)cpupower
 	-rm -f $(OUTPUT)libcpupower.so*
-	-rm -rf $(OUTPUT)po/*.{gmo,pot}
+	-rm -rf $(OUTPUT)po/*.gmo
+	-rm -rf $(OUTPUT)po/*.pot
 	$(MAKE) -C bench O=$(OUTPUT) clean
 
 
diff --git a/tools/power/cpupower/debug/i386/Makefile b/tools/power/cpupower/debug/i386/Makefile
index 3ba158f..c05cc0a 100644
--- a/tools/power/cpupower/debug/i386/Makefile
+++ b/tools/power/cpupower/debug/i386/Makefile
@@ -26,7 +26,10 @@ $(OUTPUT)powernow-k8-decode: powernow-k8-decode.c
 all: $(OUTPUT)centrino-decode $(OUTPUT)dump_psb $(OUTPUT)intel_gsic $(OUTPUT)powernow-k8-decode
 
 clean:
-	rm -rf $(OUTPUT){centrino-decode,dump_psb,intel_gsic,powernow-k8-decode}
+	rm -rf $(OUTPUT)centrino-decode
+	rm -rf $(OUTPUT)dump_psb
+	rm -rf $(OUTPUT)intel_gsic
+	rm -rf $(OUTPUT)powernow-k8-decode
 
 install:
 	$(INSTALL) -d $(DESTDIR)${bindir}
-- 
1.7.9.5

