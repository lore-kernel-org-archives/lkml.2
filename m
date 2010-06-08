Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0FHL6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:58:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48306 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab0FHL63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:58:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 05/10] oom: enable oom tasklist dump by default
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100608204621.767A.A69D9226@jp.fujitsu.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com>
Message-Id: <20100608205749.7689.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Jun 2010 20:58:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

The oom killer tasklist dump, enabled with the oom_dump_tasks sysctl, is
very helpful information in diagnosing why a user's task has been killed.
It emits useful information such as each eligible thread's memory usage
that can determine why the system is oom, so it should be enabled by
default.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/sysctl/vm.txt |    2 +-
 mm/oom_kill.c               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 5fdbb61..3936b61 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -511,7 +511,7 @@ information may not be desired.
 If this is set to non-zero, this information is shown whenever the
 OOM killer actually kills a memory-hogging task.
 
-The default value is 0.
+The default value is 1 (enabled).
 
 ==============================================================
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 80492ff..b88172c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -31,7 +31,7 @@
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
-int sysctl_oom_dump_tasks;
+int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
-- 
1.6.5.2



