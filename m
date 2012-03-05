Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2CEQWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:22:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab2CEQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:22:18 -0500
Date: Mon, 5 Mar 2012 08:21:25 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ef7c537221160c285704997a913fb66ddc1fe6bc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1329986784-4916-3-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-3-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Handle lower case key code in annotate_browser__run()
Git-Commit-ID: ef7c537221160c285704997a913fb66ddc1fe6bc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 08:21:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef7c537221160c285704997a913fb66ddc1fe6bc
Gitweb:     http://git.kernel.org/tip/ef7c537221160c285704997a913fb66ddc1fe6bc
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 23 Feb 2012 17:46:21 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Mar 2012 10:15:50 -0300

perf annotate: Handle lower case key code in annotate_browser__run()

Accepting upper case character only is unconvenient since it requires
SHIFT key too. Why not change to it accept a simple key stroke?

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329986784-4916-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 76caae9..374d3bc5 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -287,9 +287,11 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				nd = self->curr_hot;
 			break;
 		case 'H':
+		case 'h':
 			nd = self->curr_hot;
 			break;
 		case 'S':
+		case 's':
 			if (annotate_browser__toggle_source(self))
 				ui_helpline__puts(help);
 			continue;
