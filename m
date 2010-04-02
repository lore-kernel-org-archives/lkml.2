Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab0DBRDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:03:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab0DBRDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:03:39 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/4] [BUGFIX] perf probe: Fix not to return non-matched
	file
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 02 Apr 2010 12:50:45 -0400
Message-ID: <20100402165045.23551.47780.stgit@localhost6.localdomain6>
In-Reply-To: <20100402165031.23551.14034.stgit@localhost6.localdomain6>
References: <20100402165031.23551.14034.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix cu_find_realpath() not to return the last file path
if that is not matched to input pattern.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 tools/perf/util/probe-finder.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index db52ec2..b44132e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -183,6 +183,8 @@ static const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname)
 		if (strtailcmp(src, fname) == 0)
 			break;
 	}
+	if (i == nfiles)
+		return NULL;
 	return src;
 }
 


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
