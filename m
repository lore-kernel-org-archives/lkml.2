Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab2GYTVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:21:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2GYTVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:21:15 -0400
Date: Wed, 25 Jul 2012 12:20:56 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-78b961ff8e67207adb15959526cdea4cc50ae1ed@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1342826756-64663-8-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-8-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Dump exclude_{guest,host},
  precise_ip header info too
Git-Commit-ID: 78b961ff8e67207adb15959526cdea4cc50ae1ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:21:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78b961ff8e67207adb15959526cdea4cc50ae1ed
Gitweb:     http://git.kernel.org/tip/78b961ff8e67207adb15959526cdea4cc50ae1ed
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 20 Jul 2012 17:25:52 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:31:19 -0300

perf tools: Dump exclude_{guest,host}, precise_ip header info too

Adds the attributes to the event line in the header dump.
From:
 event : name = cycles, type = 0, config = 0x0, config1 = 0x0,
      config2 = 0x0, excl_usr = 0, excl_kern = 0, ...
to
  event : name = cycles, type = 0, config = 0x0, config1 = 0x0,
      config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0,
      excl_guest = 0, precise_ip = 0, ...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1342826756-64663-8-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5a47aba..3a6d204 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1212,6 +1212,12 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 				attr.exclude_user,
 				attr.exclude_kernel);
 
+		fprintf(fp, ", excl_host = %d, excl_guest = %d",
+				attr.exclude_host,
+				attr.exclude_guest);
+
+		fprintf(fp, ", precise_ip = %d", attr.precise_ip);
+
 		if (nr)
 			fprintf(fp, ", id = {");
 
