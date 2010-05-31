Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0EaXCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:02:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33476 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab0EaXCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=CoNXPfWuOED3kGHhYtqtFUC0xcFoO4iWoPU7XUwoH/ZpAfTc7zPd4qCykB2ZnzyaDb
         YqFJ8UwGKdzqy2Aic2saQPA7N0b2oI1Ro091LcSYky8WK/cqSsJ6Km/blB8hBwnzNGg2
         KDwTczluOFDqQRnzzbJ50V4eZZD9A0/3IkK04=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4] perf-record: Check correct pid when forking
Date: Tue,  1 Jun 2010 01:02:20 +0200
Message-Id: <1275346940-18498-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
References: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

When forking the child to be traced, we should check the correct
return value from fork() and not a local variable which is otherwise
unused.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100531211818.GA30175@liondog.tnic>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-record.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9bc8905..dc3435e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -503,7 +503,6 @@ static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
 	struct stat st;
-	pid_t pid = 0;
 	int flags;
 	int err;
 	unsigned long waking = 0;
@@ -572,7 +571,7 @@ static int __cmd_record(int argc, const char **argv)
 
 	if (forks) {
 		child_pid = fork();
-		if (pid < 0) {
+		if (child_pid < 0) {
 			perror("failed to fork");
 			exit(-1);
 		}
-- 
1.6.2.3

