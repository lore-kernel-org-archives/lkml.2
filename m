Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2JBPXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:23:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62932 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab2JBPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:22:49 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] perf tools: Complete long option names of perf command
Date: Wed,  3 Oct 2012 00:21:33 +0900
Message-Id: <1349191294-6926-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
References: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main perf binary can receive a number of options that configure
working environment.  Add them to the completion script.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/bash_completion |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 3d48cee1b5e5..bef06f0deeb5 100644
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
-- 
1.7.9.2

