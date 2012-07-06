Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab2GFKv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:51:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51357 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab2GFKv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:51:56 -0400
Date: Fri, 6 Jul 2012 03:51:35 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-3101nsbg52glxdqih291qj74@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1340352615-20737-1-git-send-email-namhyung@kernel.org>
References: <1340352615-20737-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Teach [ce]
 tags about libtraceeevent error codes
Git-Commit-ID: 6545e3a8f0666b60b26202a5271a94f7cd9601a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:51:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6545e3a8f0666b60b26202a5271a94f7cd9601a8
Gitweb:     http://git.kernel.org/tip/6545e3a8f0666b60b26202a5271a94f7cd9601a8
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 22 Jun 2012 17:10:14 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:28:12 -0300

tools lib traceevent: Teach [ce]tags about libtraceeevent error codes

As we use a macro trick to sync each error codes with its description
string, teach [ce]tags to process them properly.

This patch modifies the libtraceevent's Makefile not a kernel one.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/tip-3101nsbg52glxdqih291qj74@git.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1340352615-20737-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 423f4b8..34a577e 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -270,11 +270,13 @@ endif
 
 tags:	force
 	$(RM) tags
-	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px
+	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px \
+	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
 
 TAGS:	force
 	$(RM) TAGS
-	find . -name '*.[ch]' | xargs etags
+	find . -name '*.[ch]' | xargs etags \
+	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'
 
 define do_install
 	$(print_install)				\
