Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2HEQpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:45:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2HEQp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:45:29 -0400
Date: Sun, 5 Aug 2012 09:45:04 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-0ecf4f0c02b7802de5d1251e03e6eab360f158e1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, drepper@gmail.com,
        tglx@linutronix.de, kirill@shutemov.name
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, drepper@gmail.com,
        tglx@linutronix.de, kirill@shutemov.name
In-Reply-To: <1343267410-7758-1-git-send-email-namhyung@kernel.org>
References: <1343267410-7758-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf target: Fix check on buffer size
Git-Commit-ID: 0ecf4f0c02b7802de5d1251e03e6eab360f158e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:45:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ecf4f0c02b7802de5d1251e03e6eab360f158e1
Gitweb:     http://git.kernel.org/tip/0ecf4f0c02b7802de5d1251e03e6eab360f158e1
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 26 Jul 2012 10:50:10 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Aug 2012 18:42:54 -0300

perf target: Fix check on buffer size

It was a mistake just replace assert to BUG_ON since its condition
should be negated. Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1343267410-7758-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/target.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 3f59c49..051eaa6 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -110,7 +110,7 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 	int idx;
 	const char *msg;
 
-	BUG_ON(buflen > 0);
+	BUG_ON(buflen == 0);
 
 	if (errnum >= 0) {
 		const char *err = strerror_r(errnum, buf, buflen);
