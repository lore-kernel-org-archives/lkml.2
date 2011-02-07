Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab1BGPA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:00:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58904 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1BGPAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:00:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/9] tracing/kprobes: Cleanup strict_strtol() using code
Date: Mon,  7 Feb 2011 13:00:07 -0200
Message-Id: <1297090812-10782-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297090812-10782-1-git-send-email-acme@infradead.org>
References: <1297090812-10782-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Since strict_strtol() accepts minus digits started with '-', it doesn't
need to invert after converting.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20110204125153.9507.49335.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace_kprobe.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2dec9bc..2088893 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -767,16 +767,15 @@ static int __parse_probe_arg(char *arg, const struct fetch_type *t,
 		}
 		break;
 	case '+':	/* deref memory */
+		arg++;	/* Skip '+', because strict_strtol() rejects it. */
 	case '-':
 		tmp = strchr(arg, '(');
 		if (!tmp)
 			break;
 		*tmp = '\0';
-		ret = strict_strtol(arg + 1, 0, &offset);
+		ret = strict_strtol(arg, 0, &offset);
 		if (ret)
 			break;
-		if (arg[0] == '-')
-			offset = -offset;
 		arg = tmp + 1;
 		tmp = strrchr(arg, ')');
 		if (tmp) {
-- 
1.6.2.5

