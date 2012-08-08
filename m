Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586Ab2HHRN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:13:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54084 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030569Ab2HHRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:13:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/11] perf tools: Fix version file for perf documentation with OUTPUT variable set
Date: Wed,  8 Aug 2012 14:13:38 -0300
Message-Id: <1344446028-21381-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344446028-21381-1-git-send-email-acme@infradead.org>
References: <1344446028-21381-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Fixes the following:

 + make OUTPUT=/.../.build/perf-user/ DESTDIR=/.../.install/perf-user/ man install-man
 make -C Documentation man
 make[1]: Entering directory `/.../.source/linux.perf/tools/perf/Documentation'
 make[2]: Entering directory `/.../.source/linux.perf/tools/perf'
 make[2]: *** No rule to make target `PERF-VERSION-FILE'.  Stop.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-2-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index ca600e0..9f2e44f 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -195,10 +195,10 @@ install-pdf: pdf
 #install-html: html
 #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
 
-../PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
-	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) PERF-VERSION-FILE
+$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
+	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) $(OUTPUT)PERF-VERSION-FILE
 
--include ../PERF-VERSION-FILE
+-include $(OUTPUT)PERF-VERSION-FILE
 
 #
 # Determine "include::" file references in asciidoc files.
-- 
1.7.9.2.358.g22243

