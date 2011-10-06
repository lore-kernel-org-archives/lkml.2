Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab1JFRXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:23:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50252 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab1JFRWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/15] perf hists browser: Fix TAB/UNTAB use with multiple events
Date: Thu,  6 Oct 2011 14:22:36 -0300
Message-Id: <1317921758-4154-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When requesting multiple events, say:

  # perf top -e instructions -e cycles -e cache-misses

The first screen lets the user chose what to see first, then to switch
one can either use the left key to get back to the event menu or simply
use TAB to go the next and shift+TAB to go the prev.

When using TAB/UNTAB the call to perf_evlist__set_selected(event) was
missing, fix it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3xqqh3fwmt914gg43frey14y@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index b790109..ef6ccef 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -1107,12 +1107,14 @@ browse_hists:
 				pos = list_entry(evlist->entries.next, struct perf_evsel, node);
 			else
 				pos = list_entry(pos->node.next, struct perf_evsel, node);
+			perf_evlist__set_selected(evlist, pos);
 			goto browse_hists;
 		case NEWT_KEY_UNTAB:
 			if (pos->node.prev == &evlist->entries)
 				pos = list_entry(evlist->entries.prev, struct perf_evsel, node);
 			else
 				pos = list_entry(pos->node.prev, struct perf_evsel, node);
+			perf_evlist__set_selected(evlist, pos);
 			goto browse_hists;
 		case 'q':
 		case CTRL('c'):
-- 
1.6.2.5

