Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab2G1Drb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 23:47:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab2G1Dra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 23:47:30 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -mm] fault-injection: fix failcmd.sh warning
Date: Sat, 28 Jul 2012 12:47:02 +0900
Message-Id: <1343447222-4443-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch
in -mm tree adds tools/testing/fault-injection/failcmd.sh to make it
easier to inject slab/page allocation failures by fault injection.

failcmd.sh prints the following warning when running with arguments
for command.

	# ./failcmd.sh echo aaa
	failcmd.sh: line 209: [: echo: binary operator expected
	aaa

This warning is caused by an improper check whether at least one
parameter is left after parsing command options.

Fix it by testing the length of $1 instead of $@

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 tools/testing/fault-injection/failcmd.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/fault-injection/failcmd.sh b/tools/testing/fault-injection/failcmd.sh
index 1776e92..78a9ed7 100755
--- a/tools/testing/fault-injection/failcmd.sh
+++ b/tools/testing/fault-injection/failcmd.sh
@@ -206,7 +206,7 @@ while true; do
 	esac
 done
 
-[ -z "$@" ] && exit 0
+[ -z "$1" ] && exit 0
 
 echo $oom_kill_allocating_task > /proc/sys/vm/oom_kill_allocating_task
 echo $task_filter > $FAULTATTR/task-filter
-- 
1.7.10.4

