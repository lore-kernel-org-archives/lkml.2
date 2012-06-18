Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2FRCyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:54:47 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53084 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2FRCyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:54:44 -0400
X-AuditID: 9c93016f-b7c35ae00000135b-c6-4fde986a7085
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH v2 5/5] scripts/tags.sh: Teach [ce]tags about libtraceeevent error codes
Date: Mon, 18 Jun 2012 11:50:51 +0900
Message-Id: <1339987851-22491-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
References: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As we use a macro trick to sync each error codes with its
description string, teach [ce]tags to process them properly.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Link: http://lkml.kernel.org/n/tip-qt5fv4pzigr2nnl27ydimg4h@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 scripts/tags.sh |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index cf7b12fee573..cff8faad73d1 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -153,7 +153,8 @@ exuberant()
 	--regex-c++='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
 	--regex-c++='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/'	\
 	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
-	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
+	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
+	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -195,7 +196,8 @@ emacs()
 	--regex='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
 	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
 	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
-	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
+	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
+	--regex='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
-- 
1.7.10.2

