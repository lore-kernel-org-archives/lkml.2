Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab0DNWan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab0DNWak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:30:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/6] perf probe: Fix mis-estimation for shortening
	filename
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 Apr 2010 18:37:07 -0400
Message-ID: <20100414223707.14224.39135.stgit@localhost6.localdomain6>
In-Reply-To: <20100414223652.14224.28067.stgit@localhost6.localdomain6>
References: <20100414223652.14224.28067.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix mis-estimation size for making a short filename.
Since the buffer size is 32 bytes and there are '@' prefix and
'\0' termination, maximum shorten filename length should be
30. This means, before searching '/', it should be 31 bytes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 tools/perf/util/probe-event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1c4a20a..6d43839 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -806,12 +806,12 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 			goto error;
 	}
 	if (pp->file) {
-		len = strlen(pp->file) - 32;
+		len = strlen(pp->file) - 31;
 		if (len < 0)
 			len = 0;
 		tmp = strchr(pp->file + len, '/');
 		if (!tmp)
-			tmp = pp->file + len - 1;
+			tmp = pp->file + len;
 		ret = e_snprintf(file, 32, "@%s", tmp + 1);
 		if (ret <= 0)
 			goto error;


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
