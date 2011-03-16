Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab1CPCQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:16:44 -0400
Received: from prod-mail-xrelay04.akamai.com ([96.6.114.79]:57911 "EHLO
	prod-mail-xrelay04.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab1CPCQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:16:41 -0400
From: Josh Hunt <johunt@akamai.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Tapan Dhimant <tdhimant@akamai.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: version incorrect with some versions of grep
Date: Tue, 15 Mar 2011 19:16:40 -0700
Message-Id: <1300241800-30281-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some versions of grep don't treat '\s' properly. When building perf on
such systems and using a kernel tarball the perf version is unable to be
determined from the main kernel Makefile and the user is left with a version
of '..'. Replacing the use of '\s' with '[[:space:]]', which should work
in all grep versions, gives a usable version number.

Reported-by: Tapan Dhimant <tdhimant@akamai.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 tools/perf/util/PERF-VERSION-GEN |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 97d7656..26d4d3f 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -23,10 +23,10 @@ if test -d ../../.git -o -f ../../.git &&
 then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
-	eval `grep '^VERSION\s*=' ../../Makefile|tr -d ' '`
-	eval `grep '^PATCHLEVEL\s*=' ../../Makefile|tr -d ' '`
-	eval `grep '^SUBLEVEL\s*=' ../../Makefile|tr -d ' '`
-	eval `grep '^EXTRAVERSION\s*=' ../../Makefile|tr -d ' '`
+	eval $(grep '^VERSION[[:space:]]*=' ../../Makefile|tr -d ' ')
+	eval $(grep '^PATCHLEVEL[[:space:]]*=' ../../Makefile|tr -d ' ')
+	eval $(grep '^SUBLEVEL[[:space:]]*=' ../../Makefile|tr -d ' ')
+	eval $(grep '^EXTRAVERSION[[:space:]]*=' ../../Makefile|tr -d ' ')
 
 	VN="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"
 fi
-- 
1.7.0.4

