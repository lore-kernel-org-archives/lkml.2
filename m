Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2CEQXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:23:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60924 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2CEQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:23:04 -0500
Date: Mon, 5 Mar 2012 08:22:13 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-142cfbd0a0353bbcf4ce62f1d4b4ffaa5fe228f9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1329986784-4916-4-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-4-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Restore title when came back to original symbol
Git-Commit-ID: 142cfbd0a0353bbcf4ce62f1d4b4ffaa5fe228f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 08:22:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  142cfbd0a0353bbcf4ce62f1d4b4ffaa5fe228f9
Gitweb:     http://git.kernel.org/tip/142cfbd0a0353bbcf4ce62f1d4b4ffaa5fe228f9
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 23 Feb 2012 17:46:22 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Mar 2012 10:15:50 -0300

perf annotate: Restore title when came back to original symbol

On tui annotation, the title was set to name of the target symbol if
user selects the target. However it remained after returning to original
symbol from the target. Fix it.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329986784-4916-4-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 374d3bc5..e733577 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -343,6 +343,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				pthread_mutex_unlock(&notes->lock);
 				symbol__tui_annotate(target, ms->map, evidx,
 						     timer, arg, delay_secs);
+				ui_browser__show_title(&self->b, sym->name);
 			}
 			continue;
 		case K_LEFT:
