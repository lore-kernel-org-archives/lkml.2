Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab2EXKiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:38:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab2EXKiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:38:04 -0400
Date: Thu, 24 May 2012 03:37:35 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-5e8wolcjs3rgd5i6yi995gfh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Explicititely initialize input_name
Git-Commit-ID: a1d44b9acdf7b2820ef762846150b4d13b84e075
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 03:37:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1d44b9acdf7b2820ef762846150b4d13b84e075
Gitweb:     http://git.kernel.org/tip/a1d44b9acdf7b2820ef762846150b4d13b84e075
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 23 May 2012 21:47:51 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 May 2012 21:47:51 -0300

perf evlist: Explicititely initialize input_name

It was a global variable, so it was initialized, implicitely, to zero by
being placed in the bss.

Now it is just a local variable that is then passed to the __cmd_evlist
routine, so it must be explicitely set to NULL.

The problem manifested on a Fedora 17 system, using:

 gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC)

But not on several other systems, by luck.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5e8wolcjs3rgd5i6yi995gfh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-evlist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index e52d77e..acd78dc 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -116,7 +116,7 @@ static const char * const evlist_usage[] = {
 int cmd_evlist(int argc, const char **argv, const char *prefix __used)
 {
 	struct perf_attr_details details = { .verbose = false, };
-	const char *input_name;
+	const char *input_name = NULL;
 	const struct option options[] = {
 		OPT_STRING('i', "input", &input_name, "file",
 			    "Input file name"),
