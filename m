Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2FFHEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:04:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2FFHEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:04:41 -0400
Date: Wed, 6 Jun 2012 00:04:25 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-55da80059de6c7533724fcd95f16c5d5618ecf4d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1338443506-25009-3-git-send-email-namhyung.kim@lge.com>
References: <1338443506-25009-3-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist:
  Pass third argument to ioctl explicitly
Git-Commit-ID: 55da80059de6c7533724fcd95f16c5d5618ecf4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:04:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55da80059de6c7533724fcd95f16c5d5618ecf4d
Gitweb:     http://git.kernel.org/tip/55da80059de6c7533724fcd95f16c5d5618ecf4d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 31 May 2012 14:51:46 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 May 2012 11:39:16 -0300

perf evlist: Pass third argument to ioctl explicitly

The ioctl on perf event fd wants 3 arguments but we only passed 2. As
the only user of the functions is perf record and it calls them for
every event (regardless of group setting), just pass 0 for now.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338443506-25009-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ed277e5..7400fb3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -274,7 +274,8 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
-				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_DISABLE);
+				ioctl(FD(pos, cpu, thread),
+				      PERF_EVENT_IOC_DISABLE, 0);
 		}
 	}
 }
@@ -287,7 +288,8 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			for (thread = 0; thread < evlist->threads->nr; thread++)
-				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_ENABLE);
+				ioctl(FD(pos, cpu, thread),
+				      PERF_EVENT_IOC_ENABLE, 0);
 		}
 	}
 }
