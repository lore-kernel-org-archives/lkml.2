Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1L2Uxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:53:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab1L2Uxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:53:31 -0500
Date: Thu, 29 Dec 2011 12:53:06 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-002c4fd92d772becf8745b9cbcebe5c95fe6dad0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1323248577-11268-3-git-send-email-robert.richter@amd.com>
References: <1323248577-11268-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix out-of-bound access to struct perf_session
Git-Commit-ID: 002c4fd92d772becf8745b9cbcebe5c95fe6dad0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:53:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  002c4fd92d772becf8745b9cbcebe5c95fe6dad0
Gitweb:     http://git.kernel.org/tip/002c4fd92d772becf8745b9cbcebe5c95fe6dad0
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 7 Dec 2011 10:02:52 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Dec 2011 16:57:41 -0200

perf tools: Fix out-of-bound access to struct perf_session

If filename is NULL there is an out-of-bound access to struct
perf_session if it would be used with perf_session__open(). Shouldn't
actually happen in current implementation as filename is always !NULL.
Fixing this by always null-terminating filename.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323248577-11268-3-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    2 +-
 tools/perf/util/session.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d9318d8..ea17dfb 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -107,7 +107,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force, bool repipe,
 				       struct perf_tool *tool)
 {
-	size_t len = filename ? strlen(filename) + 1 : 0;
+	size_t len = filename ? strlen(filename) : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
 
 	if (self == NULL)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index fb69612..37bc383 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -50,7 +50,7 @@ struct perf_session {
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
-	char			filename[0];
+	char			filename[1];
 };
 
 struct perf_tool;
