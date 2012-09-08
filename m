Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab2IHLqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:46:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2IHLqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:46:50 -0400
Date: Sat, 8 Sep 2012 04:46:28 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-7b45f21c2e42f265f6fd469e43857e98e2fdf01c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1347065004-15306-10-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-10-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: replace mkostemp with mkstemp
Git-Commit-ID: 7b45f21c2e42f265f6fd469e43857e98e2fdf01c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:46:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b45f21c2e42f265f6fd469e43857e98e2fdf01c
Gitweb:     http://git.kernel.org/tip/7b45f21c2e42f265f6fd469e43857e98e2fdf01c
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Sat, 8 Sep 2012 03:43:21 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 22:10:44 -0300

perf tools: replace mkostemp with mkstemp

The mkostemp function is only available in glibc. This leads to compile
error in Android, since bionic is derived from BSD.

Replacing mkostemp with mkstemp. mkstemp is available on both glibc and
bionic.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-10-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso-test-data.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/dso-test-data.c b/tools/perf/util/dso-test-data.c
index 541cdc7..c6caede 100644
--- a/tools/perf/util/dso-test-data.c
+++ b/tools/perf/util/dso-test-data.c
@@ -23,7 +23,7 @@ static char *test_file(int size)
 	int fd, i;
 	unsigned char *buf;
 
-	fd = mkostemp(templ, O_CREAT|O_WRONLY|O_TRUNC);
+	fd = mkstemp(templ);
 
 	buf = malloc(size);
 	if (!buf) {
