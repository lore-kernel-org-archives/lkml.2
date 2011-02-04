Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1BDM6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:58:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40880 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab1BDM6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:58:46 -0500
X-AuditID: b753bd60-a4f4eba0000001d0-d0-4d4bf803b38a
X-AuditID: b753bd60-a4f4eba0000001d0-d0-4d4bf803b38a
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 1/4] tracing/kprobes: Cleanup strict_strtol()
	using code
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 04 Feb 2011 21:51:53 +0900
Message-ID: <20110204125153.9507.49335.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110204125145.9507.5169.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110204125145.9507.5169.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since strict_strtol() accepts minus digits started with '-',
it doesn' need to invert after converting.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
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

