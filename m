Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1DTQYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:24:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1DTQYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:24:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Michael Witten <mfwitten@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf tools: Move `try-cc'
Date: Wed, 20 Apr 2011 13:23:54 -0300
Message-Id: <1303316636-11923-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1303316636-11923-1-git-send-email-acme@infradead.org>
References: <1303316636-11923-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Witten <mfwitten@gmail.com>

The `try-cc' user-defined function was in tools/perf/feature-tests.mak;
this commit moves it to tools/perf/config/utilities.mak.

Signed-off-by: Michael Witten <mfwitten@gmail.com>
Link: http://lkml.kernel.org/n/tip-bqhwcuxsrve0iodn6q4ejaoi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/utilities.mak |    8 ++++++++
 tools/perf/feature-tests.mak    |    8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 6d8ff88..8046182 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -178,3 +178,11 @@ endef
 _ge_attempt = $(or $(get-executable),$(_gea_warn),$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
+
+# try-cc
+# Usage: option = $(call try-cc, source-to-build, cc-options)
+try-cc = $(shell sh -c						  \
+	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
+	 echo "$(1)" |						  \
+	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
+	 rm -f "$$TMP"')
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index 1b33420..6170fd2 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -126,11 +126,3 @@ int main(void)
 	return 0;
 }
 endef
-
-# try-cc
-# Usage: option = $(call try-cc, source-to-build, cc-options)
-try-cc = $(shell sh -c						  \
-	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
-	 echo "$(1)" |						  \
-	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
-	 rm -f "$$TMP"')
-- 
1.6.2.5

