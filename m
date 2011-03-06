Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1CFUtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:49:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab1CFUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, William Cohen <wcohen@redhat.com>
Subject: [PATCH 1/6] perf report tui: Fix multi event switching
Date: Sun,  6 Mar 2011 17:48:22 -0300
Message-Id: <1299444507-26549-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299444507-26549-1-git-send-email-acme@infradead.org>
References: <1299444507-26549-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

TAB/UNTAB were not hotkeys, so didn't exit hists__browse back to
hists__tui_browse_tree, allowing just the first event to be browsed.

Reported-by: William Cohen <wcohen@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: William Cohen <wcohen@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 497b3c4..c27ab35 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -292,7 +292,8 @@ static int hist_browser__run(struct hist_browser *self, const char *title)
 {
 	int key;
 	int exit_keys[] = { 'a', '?', 'h', 'C', 'd', 'D', 'E', 't',
-			    NEWT_KEY_ENTER, NEWT_KEY_RIGHT, NEWT_KEY_LEFT, 0, };
+			    NEWT_KEY_ENTER, NEWT_KEY_RIGHT, NEWT_KEY_LEFT,
+			    NEWT_KEY_TAB, NEWT_KEY_UNTAB, 0, };
 
 	self->b.entries = &self->hists->entries;
 	self->b.nr_entries = self->hists->nr_entries;
@@ -859,6 +860,7 @@ int hists__browse(struct hists *self, const char *helpline,
 					"E         Expand all callchains\n"
 					"d         Zoom into current DSO\n"
 					"t         Zoom into current Thread\n"
+					"TAB/UNTAB Switch events\n"
 					"q/CTRL+C  Exit browser");
 			continue;
 		case NEWT_KEY_ENTER:
@@ -997,6 +999,7 @@ int hists__tui_browse_tree(struct rb_root *self, const char *help, int evidx)
 			if (nd == first)
 				continue;
 			nd = rb_prev(nd);
+			break;
 		default:
 			return key;
 		}
-- 
1.6.2.5

