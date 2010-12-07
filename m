Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0LGG5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:57:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:53472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0LGG5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:57:10 -0500
Date: Tue, 7 Dec 2010 06:56:48 GMT
From: tip-bot for Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, akihiro.nagai.hw@hitachi.com,
        peterz@infradead.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        akihiro.nagai.hw@hitachi.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101203035853.7827.17502.stgit@localhost6.localdomain6>
References: <20101203035853.7827.17502.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf options: add OPT_CALLBACK_DEFAULT_NOOPT
Message-ID: <tip-e4e18d568b0e833c75c1f7833e1690cdde8f4d76@git.kernel.org>
Git-Commit-ID: e4e18d568b0e833c75c1f7833e1690cdde8f4d76
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 06:56:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4e18d568b0e833c75c1f7833e1690cdde8f4d76
Gitweb:     http://git.kernel.org/tip/e4e18d568b0e833c75c1f7833e1690cdde8f4d76
Author:     Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
AuthorDate: Fri, 3 Dec 2010 12:58:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Dec 2010 15:33:29 -0200

perf options: add OPT_CALLBACK_DEFAULT_NOOPT

Add new macro OPT_CALLBACK_DEFAULT_NOOPT for parse_options.

It enables to pass the default value (opt->defval) to the callback function
processing options require no argument.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101203035853.7827.17502.stgit@localhost6.localdomain6>
Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-options.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index c7d72dc..abc31a1 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -119,6 +119,10 @@ struct option {
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .flags = PARSE_OPT_NOARG }
 #define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d, .flags = PARSE_OPT_LASTARG_DEFAULT }
+#define OPT_CALLBACK_DEFAULT_NOOPT(s, l, v, a, h, f, d) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l),\
+	.value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d,\
+	.flags = PARSE_OPT_LASTARG_DEFAULT | PARSE_OPT_NOARG}
 
 /* parse_options() will filter out the processed options and leave the
  * non-option argments in argv[].
