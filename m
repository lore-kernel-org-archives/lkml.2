Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2AVVI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 16:08:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50508 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2AVVI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 16:08:56 -0500
Date: Sun, 22 Jan 2012 13:08:13 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-46cd6a7f680d14f6f80ede9f04aeb70fa83bd266@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1327021966-27688-2-git-send-email-namhyung.kim@lge.com>
References: <1327021966-27688-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Call perf_cgroup_event_time() directly
Git-Commit-ID: 46cd6a7f680d14f6f80ede9f04aeb70fa83bd266
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 22 Jan 2012 13:08:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46cd6a7f680d14f6f80ede9f04aeb70fa83bd266
Gitweb:     http://git.kernel.org/tip/46cd6a7f680d14f6f80ede9f04aeb70fa83bd266
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 20 Jan 2012 10:12:46 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Jan 2012 09:33:42 +0100

perf: Call perf_cgroup_event_time() directly

The perf_event_time() will call perf_cgroup_event_time()
if @event is a cgroup event. Just do it directly and avoid
the extra check..

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1327021966-27688-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a8f4ac0..32b48c8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -815,7 +815,7 @@ static void update_event_times(struct perf_event *event)
 	 * here.
 	 */
 	if (is_cgroup_event(event))
-		run_end = perf_event_time(event);
+		run_end = perf_cgroup_event_time(event);
 	else if (ctx->is_active)
 		run_end = ctx->time;
 	else
