Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0DUTur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab0DUTup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:50:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/4] [BUGFIX] perf tools: Initialize dso->node member in
	dso__new
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Wed, 21 Apr 2010 15:56:16 -0400
Message-ID: <20100421195616.24664.89980.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dso->node member is not initilized, it causes a segmentation
fault when adding to other lists. It should be initilized in
dso__new().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 tools/perf/util/symbol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e782e7d..e77c33a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -189,6 +189,7 @@ struct dso *dso__new(const char *name)
 		self->sorted_by_name = 0;
 		self->has_build_id = 0;
 		self->kernel = DSO_TYPE_USER;
+		INIT_LIST_HEAD(&self->node);
 	}
 
 	return self;


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
