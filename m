Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2BQJ4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:56:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38765 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BQJ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:56:13 -0500
Date: Fri, 17 Feb 2012 01:55:36 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-7e1ccd3804281fc0755eb726b654469c40a96d89@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120209151238.GA10272@quad>
References: <20120209151238.GA10272@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: cleanup initialization of attr->size
Git-Commit-ID: 7e1ccd3804281fc0755eb726b654469c40a96d89
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:55:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e1ccd3804281fc0755eb726b654469c40a96d89
Gitweb:     http://git.kernel.org/tip/7e1ccd3804281fc0755eb726b654469c40a96d89
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 16:12:38 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 23:35:04 -0200

perf tools: cleanup initialization of attr->size

The perf_event_attr size needs to be initialized in all cases because it
captures the ABI version.

This patch moves the initialization of the field from the
perf_event_open() syscall stub to its proper location in the
event_attr_init().

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120209151238.GA10272@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h      |    1 -
 tools/perf/util/util.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index deb17db..03a0456 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -167,7 +167,6 @@ sys_perf_event_open(struct perf_event_attr *attr,
 		      pid_t pid, int cpu, int group_fd,
 		      unsigned long flags)
 {
-	attr->size = sizeof(*attr);
 	return syscall(__NR_perf_event_open, attr, pid, cpu,
 		       group_fd, flags);
 }
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index fb25d13..8109a90 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -14,6 +14,8 @@ void event_attr_init(struct perf_event_attr *attr)
 		attr->exclude_host  = 1;
 	if (!perf_guest)
 		attr->exclude_guest = 1;
+	/* to capture ABI version */
+	attr->size = sizeof(*attr);
 }
 
 int mkdir_p(char *path, mode_t mode)
