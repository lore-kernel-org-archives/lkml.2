Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0JZA3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:29:32 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33994 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0JZA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:29:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 5/5] perf python scripting: Support fedora 11 (audit 1.7.17)
Date: Mon, 25 Oct 2010 22:29:17 -0200
Message-Id: <1288052957-14087-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1288052957-14087-1-git-send-email-acme@infradead.org>
References: <1288052957-14087-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

