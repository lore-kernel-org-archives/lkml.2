Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2EBQ1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 12:27:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:54423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2EBQ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 12:27:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf build-id: Fix filename size calculation
Date: Wed,  2 May 2012 13:27:03 -0300
Message-Id: <1335976024-13067-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335976024-13067-1-git-send-email-acme@infradead.org>
References: <1335976024-13067-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The filename is a pointer variable so the sizeof(filename) will return
length of a pointer. Fix it by using 'size'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335881976-3282-1-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c7c2d7..c0b70c6 100644
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
1.7.9.2.358.g22243

