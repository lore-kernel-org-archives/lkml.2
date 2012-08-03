Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2HCOCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:02:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:45798 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab2HCOB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:01:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/18] perf symbols: Fix array sizes for binary types arrays
Date: Fri,  3 Aug 2012 11:00:54 -0300
Message-Id: <1344002470-5965-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344002470-5965-1-git-send-email-acme@infradead.org>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Following commit introduced wrong array boundaries, that could lead to
SIGSEGV.

  perf symbols: Factor DSO symtab types to generic binary types
  commit 44f24cb3156a1e7d2b6bb501b7f6153aed08994c
  Author: Jiri Olsa <jolsa@redhat.com>

Fixing to use proper array size.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Link: http://lkml.kernel.org/r/1343825277-10517-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fdad4ee..fe86612 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -64,7 +64,7 @@ static enum dso_binary_type binary_type_symtab[] = {
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
-#define DSO_BINARY_TYPE__SYMTAB_CNT sizeof(binary_type_symtab)
+#define DSO_BINARY_TYPE__SYMTAB_CNT ARRAY_SIZE(binary_type_symtab)
 
 static enum dso_binary_type binary_type_data[] = {
 	DSO_BINARY_TYPE__BUILD_ID_CACHE,
@@ -72,7 +72,7 @@ static enum dso_binary_type binary_type_data[] = {
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
-#define DSO_BINARY_TYPE__DATA_CNT sizeof(binary_type_data)
+#define DSO_BINARY_TYPE__DATA_CNT ARRAY_SIZE(binary_type_data)
 
 int dso__name_len(const struct dso *dso)
 {
-- 
1.7.1

