Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0EaVSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:18:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57251 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab0EaVSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:18:22 -0400
Date: Mon, 31 May 2010 23:18:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf-record: Check correct pid when forking
Message-ID: <20100531211818.GA30175@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When forking the child to be traced, we should check the correct return
value from fork() and not a local variable which is otherwise unused.

Signed-off-by: Borislav Petkov <bp@alien8.de>
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
1.7.1


-- 
Regards/Gruss,
    Boris.
