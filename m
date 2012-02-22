Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2BVQNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:13:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab2BVQNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:13:06 -0500
Date: Wed, 22 Feb 2012 17:13:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH] thp: 'transparent_hugepage=' can also be specified on
 cmdline
Message-ID: <alpine.LNX.2.00.1202221710050.31150@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Behavior of THP can either be toggled through sysfs in runtime or using a 
kernel cmdline parameter 'transparent_hugepage='. Document the latter.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 Documentation/vm/transhuge.txt      |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 033d4e6..a4de9b9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2629,6 +2629,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			to facilitate early boot debugging.
 			See also Documentation/trace/events.txt
 
+	transparent_hugepage=
+			[KNL]
+			Format: [always|madvise|never]
+			Can be used to control the default behavior of the system
+			with respect to transparent hugepages.
+			See Documentation/vm/transhuge.txt for more details.
+
 	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
diff --git a/Documentation/vm/transhuge.txt b/Documentation/vm/transhuge.txt
index 29bdf62..4a3816d 100644
--- a/Documentation/vm/transhuge.txt
+++ b/Documentation/vm/transhuge.txt
@@ -103,6 +103,9 @@ echo always >/sys/kernel/mm/transparent_hugepage/enabled
 echo madvise >/sys/kernel/mm/transparent_hugepage/enabled
 echo never >/sys/kernel/mm/transparent_hugepage/enabled
 
+The always/madvise/never value can also be specified on the kernel boot
+commandline using 'transparent_hugepage=' parameter.
+
 It's also possible to limit defrag efforts in the VM to generate
 hugepages in case they're not immediately free to madvise regions or
 to never try to defrag memory and simply fallback to regular pages
-- 
1.7.3.1

