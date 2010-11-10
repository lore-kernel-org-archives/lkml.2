Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0KJSKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:10:42 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33622 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab0KJSKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:10:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fPnMgI6F5j6DNKYLdTdqH+JJlFhAecuz0ZOWzxyWabyUi6GHwrstt0GmzdUiMiBLKI
         JgD/iEW83w0DZBbfkqQKoK7jyIjSyCGIHUUJthAsFROW3P9Sa0EUyddlki9wSNgO2Opy
         j9eJE4iSYK5uZ0z9W3n9GxtBHvCaqy/J85qg8=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 3/7] perf record: make the record options available outside perf record
Date: Wed, 10 Nov 2010 12:10:20 -0600
Message-Id: <1289412624-4772-4-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
References: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Other perf commands that invoke perf record, such as perf trace, may
want to reuse the options used by perf record.

This makes them non-static and renames them to avoid clashes with
other 'options' variables.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Acked-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/builtin-record.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4e75583..93bd2ff 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -790,7 +790,7 @@ static const char * const record_usage[] = {
 
 static bool force, append_file;
 
-static const struct option options[] = {
+const struct option record_options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
@@ -839,16 +839,16 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int i, j, err = -ENOMEM;
 
-	argc = parse_options(argc, argv, options, record_usage,
+	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target_pid == -1 && target_tid == -1 &&
 		!system_wide && !cpu_list)
-		usage_with_options(record_usage, options);
+		usage_with_options(record_usage, record_options);
 
 	if (force && append_file) {
 		fprintf(stderr, "Can't overwrite and append at the same time."
 				" You need to choose between -f and -A");
-		usage_with_options(record_usage, options);
+		usage_with_options(record_usage, record_options);
 	} else if (append_file) {
 		write_mode = WRITE_APPEND;
 	} else {
@@ -871,8 +871,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		if (thread_num <= 0) {
 			fprintf(stderr, "Can't find all threads of pid %d\n",
 					target_pid);
-			usage_with_options(record_usage, options);
+			usage_with_options(record_usage, record_options);
 		}
 	} else {
 		all_tids=malloc(sizeof(pid_t));
-- 
Tom Zanussi, Intel Open Source Technology Center

