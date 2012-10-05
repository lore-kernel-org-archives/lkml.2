Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2JEIxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:53:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2JEIxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:53:50 -0400
Date: Fri, 5 Oct 2012 01:53:34 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-35c2fde1155cc7225361edf43d8efd0aabd28a0c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1349191294-6926-3-git-send-email-namhyung@kernel.org>
References: <1349191294-6926-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Complete long option names of perf command
Git-Commit-ID: 35c2fde1155cc7225361edf43d8efd0aabd28a0c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:53:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35c2fde1155cc7225361edf43d8efd0aabd28a0c
Gitweb:     http://git.kernel.org/tip/35c2fde1155cc7225361edf43d8efd0aabd28a0c
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 3 Oct 2012 00:21:33 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:43 -0300

perf tools: Complete long option names of perf command

The main perf binary can receive a number of options that configure
working environment.  Add them to the completion script.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1349191294-6926-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 3d48cee..bef06f0 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -21,10 +21,16 @@ _perf()
 
 	cmd=${COMP_WORDS[0]}
 
-	# List perf subcommands
+	# List perf subcommands or long options
 	if [ $COMP_CWORD -eq 1 ]; then
-		cmds=$($cmd --list-cmds)
-		COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
+		if [[ $cur == --* ]]; then
+			COMPREPLY=( $( compgen -W '--help --version \
+			--exec-path --html-path --paginate --no-pager \
+			--perf-dir --work-tree --debugfs-dir' -- "$cur" ) )
+		else
+			cmds=$($cmd --list-cmds)
+			COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
+		fi
 	# List possible events for -e option
 	elif [[ $prev == "-e" && "${COMP_WORDS[1]}" == @(record|stat|top) ]]; then
 		cmds=$($cmd list --raw-dump)
