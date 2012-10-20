Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab2JTA66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:58:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab2JTA65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:58:57 -0400
Date: Fri, 19 Oct 2012 17:58:32 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-88481b6b33d6cb5edb57e5794abae4daeabd08c5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1350272383-7016-2-git-send-email-namhyung@kernel.org>
References: <1350272383-7016-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Remove warnings on JIT samples for srcline sort key
Git-Commit-ID: 88481b6b33d6cb5edb57e5794abae4daeabd08c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 17:58:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88481b6b33d6cb5edb57e5794abae4daeabd08c5
Gitweb:     http://git.kernel.org/tip/88481b6b33d6cb5edb57e5794abae4daeabd08c5
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 15 Oct 2012 12:39:43 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Oct 2012 13:05:38 -0300

perf tools: Remove warnings on JIT samples for srcline sort key

When using the srcline sort key with perf report, I see many lines of
warning related to JIT samples like below:

  addr2line: '/tmp/perf-1397.map': No such file

Since it's not a ELF binary and doesn't provide such information, just
use the raw ip address.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1350272383-7016-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index dd68f11..cfd1c0f 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -263,6 +263,9 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!self->ms.map)
 		goto out_ip;
 
+	if (!strncmp(self->ms.map->dso->long_name, "/tmp/perf-", 10))
+		goto out_ip;
+
 	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
 		 self->ms.map->dso->long_name, self->ip);
 	fp = popen(cmd, "r");
