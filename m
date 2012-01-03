Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2ACUQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:16:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:57612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab2ACUQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:16:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf script: Kill script_spec__delete
Date: Tue,  3 Jan 2012 18:16:23 -0200
Message-Id: <1325621784-10683-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1325621784-10683-1-git-send-email-acme@infradead.org>
References: <1325621784-10683-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

As script_spec__delete() frees given struct script_spec it should not be
called if we failed to allocate the struct. Also it's the only caller of
the function, we can get rid of the function itself.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325000151-4463-4-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3d4c0c7..fd1909a 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -536,12 +536,6 @@ static struct script_spec *script_spec__new(const char *spec,
 	return s;
 }
 
-static void script_spec__delete(struct script_spec *s)
-{
-	free(s->spec);
-	free(s);
-}
-
 static void script_spec__add(struct script_spec *s)
 {
 	list_add_tail(&s->node, &script_specs);
@@ -567,16 +561,11 @@ static struct script_spec *script_spec__findnew(const char *spec,
 
 	s = script_spec__new(spec, ops);
 	if (!s)
-		goto out_delete_spec;
+		return NULL;
 
 	script_spec__add(s);
 
 	return s;
-
-out_delete_spec:
-	script_spec__delete(s);
-
-	return NULL;
 }
 
 int script_spec_register(const char *spec, struct scripting_ops *ops)
-- 
1.7.8.rc0.35.gee6df

