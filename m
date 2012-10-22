Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2JVQag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:30:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:56213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2JVQaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:30:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf help: Fix --help for builtins
Date: Mon, 22 Oct 2012 14:30:23 -0200
Message-Id: <1350923425-15400-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350923425-15400-1-git-send-email-acme@infradead.org>
References: <1350923425-15400-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

It seems that commit cc5848213329 ("perf help: Remove use of die and
handle errors") caused the problem - it changed the initial value of
'help_format' from HELP_FORMAT_MAN to HELP_FORMAT_NONE.

This broke the --help option for all builtins, that would produce no
output, while 'man perf-top' would work it MANPATH is properly setup.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/87r4orj7zc.fsf@sejong.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-help.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 411ee56..178b88a 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -414,7 +414,7 @@ static int show_html_page(const char *perf_cmd)
 int cmd_help(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	bool show_all = false;
-	enum help_format help_format = HELP_FORMAT_NONE;
+	enum help_format help_format = HELP_FORMAT_MAN;
 	struct option builtin_help_options[] = {
 	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
 	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
-- 
1.7.1

