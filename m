Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0DBTJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:09:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:38570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0DBTJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:09:04 -0400
Date: Fri, 2 Apr 2010 19:08:19 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100402165045.23551.47780.stgit@localhost6.localdomain6>
References: <20100402165045.23551.47780.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix not to return non-matched file
Message-ID: <tip-c9e385826d4f1ca5a72005ab8503598f791a8dc0@git.kernel.org>
Git-Commit-ID: c9e385826d4f1ca5a72005ab8503598f791a8dc0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:08:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9e385826d4f1ca5a72005ab8503598f791a8dc0
Gitweb:     http://git.kernel.org/tip/c9e385826d4f1ca5a72005ab8503598f791a8dc0
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 2 Apr 2010 12:50:45 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:35:42 +0200

perf probe: Fix not to return non-matched file

Fix cu_find_realpath() not to return the last file path
if that is not matched to input pattern.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100402165045.23551.47780.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
