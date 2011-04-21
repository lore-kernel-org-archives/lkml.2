Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab1DUJX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:23:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:41906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab1DUJX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:23:27 -0400
Date: Thu, 21 Apr 2011 09:23:19 GMT
From: tip-bot for Michael Witten <mfwitten@gmail.com>
Message-ID: <tip-bqhwcuxsrve0iodn6q4ejaoi@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, mfwitten@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, mfwitten@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move `try-cc'
Git-Commit-ID: 7fbd065f5a2b299172502f09fc3fbde02b48f591
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 09:23:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fbd065f5a2b299172502f09fc3fbde02b48f591
Gitweb:     http://git.kernel.org/tip/7fbd065f5a2b299172502f09fc3fbde02b48f591
Author:     Michael Witten <mfwitten@gmail.com>
AuthorDate: Tue, 12 Apr 2011 20:27:59 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Apr 2011 08:18:36 -0300

perf tools: Move `try-cc'

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
