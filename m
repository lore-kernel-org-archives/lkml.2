Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1CPTso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:48:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56091 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1CPTsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:48:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Josh Hunt <johunt@akamai.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tapan Dhimant <tdhimant@akamai.com>, stable@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf tools: Version incorrect with some versions of grep
Date: Wed, 16 Mar 2011 16:48:18 -0300
Message-Id: <1300304899-21920-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300304899-21920-1-git-send-email-acme@infradead.org>
References: <1300304899-21920-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>

Some versions of grep don't treat '\s' properly. When building perf on such
systems and using a kernel tarball the perf version is unable to be determined
from the main kernel Makefile and the user is left with a version of '..'.
Replacing the use of '\s' with '[[:space:]]', which should work in all grep
versions, gives a usable version number.

Reported-by: Tapan Dhimant <tdhimant@akamai.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tapan Dhimant <tdhimant@akamai.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable@kernel.org
LKML-Reference: <1300241800-30281-1-git-send-email-johunt@akamai.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.6.2.5

