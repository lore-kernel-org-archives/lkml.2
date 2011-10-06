Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab1JFRWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:22:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50020 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab1JFRWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/15] perf top: Use the TUI interface by default
Date: Thu,  6 Oct 2011 14:22:32 -0300
Message-Id: <1317921758-4154-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To disable it either:

1. Make sure newt-devel is not installed when building it

2. Use 'perf top --stdio' just like with report

3. Edit your ~/.perfconfig or system wide config and have this there:

[tui]

	top = off

But you shouldn't, since the TUI is so much more powerful, has
integration with annotation and where lots more interesting features
will be developed, so if something annoys you (the colors?) just let me
know and I'll do my best to make it pleasant as a default.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cy2tn4uj1t7c3aqss5l25of5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b9b7fe0..cc877bc 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1140,13 +1140,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	setup_sorting(top_usage, options);
 
-	/*
- 	 * XXX For now start disabled, only using TUI if explicitely asked for.
- 	 * Change that when handle_keys equivalent gets written, live annotation
- 	 * done, etc.
- 	 */
-	use_browser = 0;
-
 	if (use_stdio)
 		use_browser = 0;
 	else if (use_tui)
-- 
1.6.2.5

