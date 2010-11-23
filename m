Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab0KWFgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:36:10 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60837 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0KWFgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:36:08 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arun Sharma <aruns@google.com>
Subject: [PATCH 1/6] perf: Display unknown rather than IP for unidentified DSO
Date: Tue, 23 Nov 2010 16:35:39 +1100
Message-Id: <1290490544-14349-2-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

In the event that a DSO has not been identified, just print out
<unknown> instead of the instruction pointer as we previously were
doing, which is pretty meaningless for a shared object (at least to the
users perspective).

The IP we print out is fairly meaningless in general anyway - it's just
one (the first) of the many addresses that were lumped together as
unidentified, and could span many shared objects and symbols. In reality
if we see this <unknown> output the debugging output (report -D) is
going to be more useful anyway as we can see all the different address
that it represents.

If we are printing the symbols we are still going to see this IP in that
column anyway since they shouldn't resolve either.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/sort.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b62a553..68dad55 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -170,7 +170,7 @@ static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
 		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
 	}
 
-	return repsep_snprintf(bf, size, "%*Lx", width, self->ip);
+	return repsep_snprintf(bf, size, "%-*s", width, "<unknown>");
 }
 
 /* --sort symbol */
-- 
1.7.2.3

