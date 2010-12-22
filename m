Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0LVL3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:29:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:34608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab0LVL3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:29:22 -0500
Date: Wed, 22 Dec 2010 11:28:47 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, phan@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        phan@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf buildid-list: Fix error return for success
Message-ID: <tip-bbde588bfacb990542eed043d89c8591d4ae9211@git.kernel.org>
Git-Commit-ID: bbde588bfacb990542eed043d89c8591d4ae9211
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:28:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbde588bfacb990542eed043d89c8591d4ae9211
Gitweb:     http://git.kernel.org/tip/bbde588bfacb990542eed043d89c8591d4ae9211
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 16 Dec 2010 09:43:47 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Dec 2010 09:43:47 -0200

perf buildid-list: Fix error return for success

It was always returning -1 (255), confusing test scripts.

Reported-by: Han Pingtian <phan@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Han Pingtian <phan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 44a47e1..c49837d 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -36,7 +36,6 @@ static const struct option options[] = {
 
 static int __cmd_buildid_list(void)
 {
-	int err = -1;
 	struct perf_session *session;
 
 	session = perf_session__new(input_name, O_RDONLY, force, false);
@@ -49,7 +48,7 @@ static int __cmd_buildid_list(void)
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
 
 	perf_session__delete(session);
-	return err;
+	return 0;
 }
 
 int cmd_buildid_list(int argc, const char **argv, const char *prefix __used)
