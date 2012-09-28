Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab2I1RrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:47:18 -0400
Received: from mail.x86-64.org ([217.9.48.20]:32891 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2I1RrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:47:17 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] perf: Build install-man target when installing
Date: Fri, 28 Sep 2012 19:47:07 +0200
Message-Id: <1348854427-12746-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <20120925174658.GD9320@aftab.osrc.amd.com>
References: <20120925174658.GD9320@aftab.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

There's a portion in the "perf list" output refering to the exact
specification of raw hardware events. Since this description is in
the perf-list manpage, make install-man be built unconditionally when
installing perf tool and change the reference in the "perf list" output
accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/perf/Makefile            | 2 +-
 tools/perf/util/parse-events.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 251dcd7fb5ac..e77741e22cfb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1027,7 +1027,7 @@ perfexec_instdir = $(prefix)/$(perfexecdir)
 endif
 perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
 
-install: all
+install: all install-man
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index bf5d033ee1b4..f84ac3984708 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1092,7 +1092,7 @@ void print_events(const char *event_glob, bool name_only)
 		printf("  %-50s [%s]\n",
 		       "cpu/t1=v1[,t2=v2,t3 ...]/modifier",
 		       event_type_descriptors[PERF_TYPE_RAW]);
-		printf("   (see 'perf list --help' on how to encode it)\n");
+		printf("   (see 'man perf-list' on how to encode it)\n");
 		printf("\n");
 
 		printf("  %-50s [%s]\n",
-- 
1.7.11.rc1

