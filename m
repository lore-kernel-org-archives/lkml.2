Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1CHJnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:43:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:46121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab1CHJnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:43:19 -0500
Date: Tue, 8 Mar 2011 09:42:47 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, wcohen@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, wcohen@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report tui: Fix multi event switching
Message-ID: <tip-a03f35ceeb3d279da35c5a914ac01a4b1effb0a1@git.kernel.org>
Git-Commit-ID: a03f35ceeb3d279da35c5a914ac01a4b1effb0a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Mar 2011 09:42:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a03f35ceeb3d279da35c5a914ac01a4b1effb0a1
Gitweb:     http://git.kernel.org/tip/a03f35ceeb3d279da35c5a914ac01a4b1effb0a1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 3 Mar 2011 16:43:03 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 5 Mar 2011 22:31:04 -0300

perf report tui: Fix multi event switching

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
