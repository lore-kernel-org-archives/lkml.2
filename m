Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1GQJaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:30:18 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57547 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab1GQJaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:30:03 -0400
X-AuditID: b753bd60-a3c7dba0000050a4-2c-4e22ab9779dd
X-AuditID: b753bd60-a3c7dba0000050a4-2c-4e22ab9779dd
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v2 1/6] [BUGFIX] perf script: print correct IP address
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Sun, 17 Jul 2011 18:30:45 +0900
Message-ID: <20110717093045.3447.27199.stgit@linux3>
In-Reply-To: <20110717093031.3447.52715.stgit@linux3>
References: <20110717093031.3447.52715.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_session_print_ip() prints addr_location->addr as IP address.
It's not always same as IP address. To correct it, this function
must print sample->ip.

Changes in v2:
 - add this patch

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 080e533..453a010 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1263,7 +1263,7 @@ void perf_session__print_ip(union perf_event *event,
 		}
 
 	} else {
-		printf("%16" PRIx64, al.addr);
+		printf("%16" PRIx64, sample->ip);
 		if (print_sym) {
 			if (al.sym && al.sym->name)
 				symname = al.sym->name;

