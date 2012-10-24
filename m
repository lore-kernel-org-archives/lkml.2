Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab2JXGEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:04:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab2JXGEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:04:47 -0400
Date: Tue, 23 Oct 2012 23:03:30 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-670ab5d21c7e168c89a36fdd2c69fb7af63d35a1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <87r4orj7zc.fsf@sejong.aot.lge.com>
References: <87r4orj7zc.fsf@sejong.aot.lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf help: Fix --help for builtins
Git-Commit-ID: 670ab5d21c7e168c89a36fdd2c69fb7af63d35a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 23 Oct 2012 23:03:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  670ab5d21c7e168c89a36fdd2c69fb7af63d35a1
Gitweb:     http://git.kernel.org/tip/670ab5d21c7e168c89a36fdd2c69fb7af63d35a1
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 22 Oct 2012 16:12:23 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Oct 2012 12:35:49 -0200

perf help: Fix --help for builtins

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
