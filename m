Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2EXBIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:08:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:60806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2EXBIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:08:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/1] perf evlist: Explicititely initialize input_name
Date: Wed, 23 May 2012 22:08:25 -0300
Message-Id: <1337821705-3941-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337821705-3941-1-git-send-email-acme@infradead.org>
References: <1337821705-3941-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was a global variable, so it was initialized, implicitely, to zero by
being placed in the bss.

Now it is just a local variable that is then passed to the __cmd_evlist
routine, so it must be explicitely set to NULL.

The problem manifested on a Fedora 17 system, using:

 gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC)

But not on several other systems, by luck.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5e8wolcjs3rgd5i6yi995gfh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-evlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index e52d77e..acd78dc 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -116,7 +116,7 @@ static const char * const evlist_usage[] = {
 int cmd_evlist(int argc, const char **argv, const char *prefix __used)
 {
 	struct perf_attr_details details = { .verbose = false, };
-	const char *input_name;
+	const char *input_name = NULL;
 	const struct option options[] = {
 		OPT_STRING('i', "input", &input_name, "file",
 			    "Input file name"),
-- 
1.7.9.2.358.g22243

