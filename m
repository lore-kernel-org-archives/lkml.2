Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab0LCEAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 23:00:47 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:53719 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab0LCEAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 23:00:46 -0500
X-AuditID: b753bd60-a7f15ba00000392d-9e-4cf86ae540b5
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip  1/7] perf: add OPT_CALLBACK_DEFAULT_NOOPT
To: linux-kernel@vger.kernel.org
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Dec 2010 12:58:53 +0900
Message-ID: <20101203035853.7827.17502.stgit@localhost6.localdomain6>
In-Reply-To: <20101203035832.7827.16528.stgit@localhost6.localdomain6>
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new macro OPT_CALLBACK_DEFAULT_NOOPT for parse_options.
It enables to pass the default value (opt->defval) to the callback function
processing options require no argument.

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
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

