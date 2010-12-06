Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0LFU2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:28:42 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59790 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab0LFU2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:28:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf options: add OPT_CALLBACK_DEFAULT_NOOPT
Date: Mon,  6 Dec 2010 18:28:15 -0200
Message-Id: <1291667298-7238-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291667298-7238-1-git-send-email-acme@infradead.org>
References: <1291667298-7238-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>

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
-- 
1.6.2.5

