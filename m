Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1CBIkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:40:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:45207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab1CBIkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:40:23 -0500
Date: Wed, 2 Mar 2011 08:39:54 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top browser: Fix up exit keys
Message-ID: <tip-c16bfe9ac389b13a37ff617a09682ecc0685960f@git.kernel.org>
Git-Commit-ID: c16bfe9ac389b13a37ff617a09682ecc0685960f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Mar 2011 08:39:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c16bfe9ac389b13a37ff617a09682ecc0685960f
Gitweb:     http://git.kernel.org/tip/c16bfe9ac389b13a37ff617a09682ecc0685960f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 25 Feb 2011 09:30:29 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Feb 2011 09:30:29 -0300

perf top browser: Fix up exit keys

The left key was exiting 'perf top --tui' when it really shouldn't, it
was too easy to leave the live annotation window and then press one too
many <- and get out of the tool altogether.

Do just like the report TUI does, ignore the left key for exit and also
ask the user when pressing ESC if that is really what is wanted.

Reported-by: Mike Galbraith <efault@gmx.de>
Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/top.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index 2f47224..e9381ec 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -10,6 +10,7 @@
 #include "../../annotate.h"
 #include "../helpline.h"
 #include "../libslang.h"
+#include "../util.h"
 #include "../../evlist.h"
 #include "../../hist.h"
 #include "../../sort.h"
@@ -174,6 +175,12 @@ static int perf_top_browser__run(struct perf_top_browser *browser)
 			if (browser->selection)
 				perf_top_browser__annotate(browser);
 			break;
+		case NEWT_KEY_LEFT:
+			continue;
+		case NEWT_KEY_ESCAPE:
+			if (!ui__dialog_yesno("Do you really want to exit?"))
+				continue;
+			/* Fall thru */
 		default:
 			goto out;
 		}
