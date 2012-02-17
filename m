Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2BQJtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:49:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2BQJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:49:41 -0500
Date: Fri, 17 Feb 2012 01:48:43 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-2cd13b0f7dd3a5df68ff4cd82af2e1f7bc2a43ab@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1328836217-9118-1-git-send-email-namhyung.kim@lge.com>
References: <1328836217-9118-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Implement islower/
 isupper macro into util.h
Git-Commit-ID: 2cd13b0f7dd3a5df68ff4cd82af2e1f7bc2a43ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:49:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cd13b0f7dd3a5df68ff4cd82af2e1f7bc2a43ab
Gitweb:     http://git.kernel.org/tip/2cd13b0f7dd3a5df68ff4cd82af2e1f7bc2a43ab
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 10 Feb 2012 10:10:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 23:15:43 -0200

perf tools: Implement islower/isupper macro into util.h

The util.h header provides various ctype macros but lacks those two.

Add them.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328836217-9118-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7917b09..0f99f39 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -199,6 +199,8 @@ static inline int has_extension(const char *filename, const char *ext)
 #undef isalpha
 #undef isprint
 #undef isalnum
+#undef islower
+#undef isupper
 #undef tolower
 #undef toupper
 
@@ -219,6 +221,8 @@ extern unsigned char sane_ctype[256];
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
 #define isprint(x) sane_istest(x,GIT_PRINT)
+#define islower(x) (sane_istest(x,GIT_ALPHA) && sane_istest(x,0x20))
+#define isupper(x) (sane_istest(x,GIT_ALPHA) && !sane_istest(x,0x20))
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
 #define toupper(x) sane_case((unsigned char)(x), 0)
 
