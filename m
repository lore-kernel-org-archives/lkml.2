Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2HAMsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab2HAMsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:48:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@ghostprotocols.net, a.p.zijlstra@chello.nl, mingo@redhat.com,
        paulus@samba.org
Cc: linux-kernel@vger.kernel.org, markus@trippelsdorf.de,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, tool: Fix array sizes for binary types arrays
Date: Wed,  1 Aug 2012 14:47:57 +0200
Message-Id: <1343825277-10517-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following commit introduced wrong array boundaries, that could
lead to SIGSEGV.

  perf symbols: Factor DSO symtab types to generic binary types
  commit 44f24cb3156a1e7d2b6bb501b7f6153aed08994c
  Author: Jiri Olsa <jolsa@redhat.com>

Fixing to use proper array size.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fdad4eee..fe86612 100644
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
1.7.7.6

