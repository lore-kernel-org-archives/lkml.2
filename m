Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab2JDSO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:14:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:39790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2JDSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 26/42] perf tools: Check existence of _get_comp_words_by_ref when bash completing
Date: Thu,  4 Oct 2012 15:08:26 -0300
Message-Id: <1349374122-27806-27-git-send-email-acme@infradead.org>
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

The '_get_comp_words_by_ref' function is available from the bash
completion v1.2 so that earlier version emits following warning:

  $ perf re<TAB>_get_comp_words_by_ref: command not found

Use older '_get_cword' method when the above function doesn't exist.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1349191294-6926-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 1958fa5..3d48cee 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -1,12 +1,23 @@
 # perf completion
 
+function_exists()
+{
+	declare -F $1 > /dev/null
+	return $?
+}
+
 have perf &&
 _perf()
 {
-	local cur cmd
+	local cur prev cmd
 
 	COMPREPLY=()
-	_get_comp_words_by_ref cur prev
+	if function_exists _get_comp_words_by_ref; then
+		_get_comp_words_by_ref cur prev
+	else
+		cur=$(_get_cword)
+		prev=${COMP_WORDS[COMP_CWORD-1]}
+	fi
 
 	cmd=${COMP_WORDS[0]}
 
-- 
1.7.1

