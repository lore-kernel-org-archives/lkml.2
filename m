Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593Ab2JZPFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:05:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2JZPFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:05:17 -0400
Date: Fri, 26 Oct 2012 08:04:24 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-b6f4f804108bd563070ab95199cbddcf7650cbf4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl, bp@amd64.org,
        namhyung@kernel.org, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, bp@amd64.org, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
References: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Do not generate dependency for system header files
Git-Commit-ID: b6f4f804108bd563070ab95199cbddcf7650cbf4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 08:04:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6f4f804108bd563070ab95199cbddcf7650cbf4
Gitweb:     http://git.kernel.org/tip/b6f4f804108bd563070ab95199cbddcf7650cbf4
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 26 Oct 2012 17:55:48 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Oct 2012 11:22:23 -0200

tools lib traceevent: Do not generate dependency for system header files

Ingo reported (again!) that 'make clean' on perf/traceevent does not
work due to some reason with system header file. Quotes Ingo:

 "Note that the old dependency related build failure thought to be
  fixed in commit 860df5833e46 is back:

   make[1]: *** No rule to make target
   `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', needed by `.trace-seq.d'.  Stop.

  'make clean' itself does not work in libtraceevent:

   comet:~/tip/tools/lib/traceevent> make clean
   make: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', needed by `.trace-seq.d'.  Stop.

  So I had to clean it out manually:

   comet:~/tip/tools/lib/traceevent> git ls-files --others | xargs rm
   comet:~/tip/tools/lib/traceevent>

  and then things build fine."

Try to fix it by excluding system headers from dependency generation.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1351241752-2919-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 04d959f..a20e320 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -253,7 +253,7 @@ all_deps := $(all_objs:%.o=.%.d)
 # let .d file also depends on the source and header files
 define check_deps
 		@set -e; $(RM) $@; \
-		$(CC) -M $(CFLAGS) $< > $@.$$$$; \
+		$(CC) -MM $(CFLAGS) $< > $@.$$$$; \
 		sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
 		$(RM) $@.$$$$
 endef
