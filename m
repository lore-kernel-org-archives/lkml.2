Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab2BFS7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:59:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab2BFS7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:59:39 -0500
Date: Mon, 6 Feb 2012 13:59:36 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: [PATCH] tools/power/x86: Configurable installs for turbostat and
 x86_energy_perf_policy
Message-ID: <20120206185936.GA5783@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow turbostat and x86_energy_perf_policy to be installed to a user
configurable directory.  This allows non-root installation as well as makes
it easier to include these tools from a packaging perspective.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 tools/power/x86/turbostat/Makefile              |    6 ++++--
 tools/power/x86/x86_energy_perf_policy/Makefile |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index fd8e1f1..7af5e8c 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -1,8 +1,10 @@
+DESTDIR ?=
+
 turbostat : turbostat.c
 
 clean :
 	rm -f turbostat
 
 install :
-	install turbostat /usr/bin/turbostat
-	install turbostat.8 /usr/share/man/man8
+	install turbostat ${DESTDIR}/usr/bin/turbostat
+	install turbostat.8 ${DESTDIR}/usr/share/man/man8
diff --git a/tools/power/x86/x86_energy_perf_policy/Makefile b/tools/power/x86/x86_energy_perf_policy/Makefile
index f458237..f9824f0 100644
--- a/tools/power/x86/x86_energy_perf_policy/Makefile
+++ b/tools/power/x86/x86_energy_perf_policy/Makefile
@@ -1,8 +1,10 @@
+DESTDIR ?= 
+
 x86_energy_perf_policy : x86_energy_perf_policy.c
 
 clean :
 	rm -f x86_energy_perf_policy
 
 install :
-	install x86_energy_perf_policy /usr/bin/
-	install x86_energy_perf_policy.8 /usr/share/man/man8/
+	install x86_energy_perf_policy ${DESTDIR}/usr/bin/
+	install x86_energy_perf_policy.8 ${DESTDIR}/usr/share/man/man8/
-- 
1.7.7.6

