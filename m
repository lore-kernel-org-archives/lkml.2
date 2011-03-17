Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1CQLE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:04:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:60721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab1CQLEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:04:25 -0400
Date: Thu, 17 Mar 2011 11:03:53 GMT
From: tip-bot for Josh Hunt <johunt@akamai.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        tdhimant@akamai.com, johunt@akamai.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, johunt@akamai.com,
        tdhimant@akamai.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1300241800-30281-1-git-send-email-johunt@akamai.com>
References: <1300241800-30281-1-git-send-email-johunt@akamai.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Version incorrect with some versions of grep
Message-ID: <tip-58d406ed6a5f1ca4bc1dba5390b718c67847fa5f@git.kernel.org>
Git-Commit-ID: 58d406ed6a5f1ca4bc1dba5390b718c67847fa5f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Mar 2011 11:03:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58d406ed6a5f1ca4bc1dba5390b718c67847fa5f
Gitweb:     http://git.kernel.org/tip/58d406ed6a5f1ca4bc1dba5390b718c67847fa5f
Author:     Josh Hunt <johunt@akamai.com>
AuthorDate: Tue, 15 Mar 2011 19:16:40 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Mar 2011 08:59:50 -0300

perf tools: Version incorrect with some versions of grep

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
