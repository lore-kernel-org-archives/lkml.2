Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2JDSJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:09:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:39691 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2JDSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/42] perf tools: Complete long option names of perf command
Date: Thu,  4 Oct 2012 15:08:27 -0300
Message-Id: <1349374122-27806-28-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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
-- 
1.7.1

