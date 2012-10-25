Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427Ab2JYH5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:57:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964967Ab2JYH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:57:26 -0400
Date: Thu, 25 Oct 2012 00:56:58 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-999no5yxlc2oqo9xjeez5zmv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove noise in python version feature test
Git-Commit-ID: feb8ada4ea5540ee986b23abd95597118729704c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 00:57:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  feb8ada4ea5540ee986b23abd95597118729704c
Gitweb:     http://git.kernel.org/tip/feb8ada4ea5540ee986b23abd95597118729704c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 9 Oct 2012 15:15:25 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 24 Oct 2012 14:20:10 -0200

perf tools: Remove noise in python version feature test

Now that the feature tests honours the V=1 make verbosity switch, add a
return to the main() routine in the python version test, to avoid this
distraction:

CHK python version
<stdin>: In function 'main':
<stdin>:5: warning: control reaches end of non-void function

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-999no5yxlc2oqo9xjeez5zmv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/feature-tests.mak |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 3ef5ec9..f5ac774 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -121,7 +121,10 @@ define SOURCE_PYTHON_VERSION
 #if PY_VERSION_HEX >= 0x03000000
 	#error
 #endif
-int main(void){}
+int main(void)
+{
+	return 0;
+}
 endef
 define SOURCE_PYTHON_EMBED
 #include <Python.h>
