Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab0JZKYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:24:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34461 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab0JZKYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:24:13 -0400
Date: Tue, 26 Oct 2010 10:23:41 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, davem@davemloft.net,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, davem@davemloft.net,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf python scripting: Support fedora 11 (audit 1.7.17)
Message-ID: <tip-7f6c1bd50d73d12f8b4ea09edb4515997f6527f5@git.kernel.org>
Git-Commit-ID: 7f6c1bd50d73d12f8b4ea09edb4515997f6527f5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 10:23:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f6c1bd50d73d12f8b4ea09edb4515997f6527f5
Gitweb:     http://git.kernel.org/tip/7f6c1bd50d73d12f8b4ea09edb4515997f6527f5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 25 Oct 2010 22:12:01 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Oct 2010 22:12:01 -0200

perf python scripting: Support fedora 11 (audit 1.7.17)

Where we don't have the audit.MACH_ARMEB constant.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
index 9d15f48..99ff1b7 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
@@ -36,7 +36,6 @@ try:
 	machine_to_id = {
 		'x86_64': audit.MACH_86_64,
 		'alpha'	: audit.MACH_ALPHA,
-		'armeb'	: audit.MACH_ARMEB,
 		'ia64'	: audit.MACH_IA64,
 		'ppc'	: audit.MACH_PPC,
 		'ppc64'	: audit.MACH_PPC64,
@@ -46,6 +45,10 @@ try:
 		'i586'	: audit.MACH_X86,
 		'i686'	: audit.MACH_X86,
 	}
+	try:
+		machine_to_id['armeb'] = audit.MACH_ARMEB
+	except:
+		pass
 	machine_id = machine_to_id[os.uname()[4]]
 except:
 	if not audit_package_warned:
