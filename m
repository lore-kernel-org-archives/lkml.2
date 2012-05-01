Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab2EAOTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 10:19:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42802 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2EAOTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 10:19:43 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf build-id: Fix filename size calculation
Date: Tue,  1 May 2012 23:19:36 +0900
Message-Id: <1335881976-3282-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The filename is a pointer variable so the sizeof(filename) will return
length of a pointer. Fix it by using 'size'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/header.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c7c2d73251f..c0b70c697a36 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -296,7 +296,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
-	snprintf(filename + len, sizeof(filename) - len, "/%s", sbuild_id);
+	snprintf(filename + len, size - len, "/%s", sbuild_id);
 
 	if (access(filename, F_OK)) {
 		if (is_kallsyms) {
-- 
1.7.9.2

