Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab0JSJT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:19:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:45488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113Ab0JSJTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:19:24 -0400
Message-ID: <4CBD6276.7070803@kernel.org>
Date: Tue, 19 Oct 2010 11:18:46 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Mel Gorman <mel@csn.ul.ie>, lkml <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>
Subject: [PATCH wq#for-next] workqueue: Clarify that schedule_on_each_cpu
 is synchronous
References: <4CB8725B.9010200@kernel.org> <20101018094403.GW30667@csn.ul.ie> <20101019133750.A1E6.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101019133750.A1E6.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 09:18:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation for schedule_on_each_cpu() states that it calls a
function on each online CPU from keventd.  This can easily be
interpreted as an asyncronous call because the description does not
mention that flush_work is called.  Clarify that it is synchronous.

tj: rephrased a bit

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Commited somewhat rephrased version.  Thank you.

 kernel/workqueue.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2c6871c..eb5c197 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2676,13 +2676,15 @@ int schedule_delayed_work_on(int cpu,
 EXPORT_SYMBOL(schedule_delayed_work_on);

 /**
- * schedule_on_each_cpu - call a function on each online CPU from keventd
+ * schedule_on_each_cpu - execute a function synchronously on each online CPU
  * @func: the function to call
  *
- * Returns zero on success.
- * Returns -ve errno on failure.
- *
+ * schedule_on_each_cpu() executes @func on each online CPU using the
+ * system workqueue and blocks until all CPUs have completed.
  * schedule_on_each_cpu() is very slow.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
  */
 int schedule_on_each_cpu(work_func_t func)
 {
-- 
1.7.1

