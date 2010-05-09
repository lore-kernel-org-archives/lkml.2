Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0EIPYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:24:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:40362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0EIPYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:24:17 -0400
Date: Sun, 9 May 2010 08:22:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
Subject: [PATCH v2  1/8] sched: Add a comment to get_cpu_idle_time_us()
Message-ID: <20100509082208.7cb721f0@infradead.org>
In-Reply-To: <20100509082126.4a080d46@infradead.org>
References: <20100509082126.4a080d46@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

The exported function get_cpu_idle_time_us() has no comment
describing it; add a kerneldoc comment

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>

---

 kernel/time/tick-sched.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN kernel/time/tick-sched.c~sched-add-a-comment-to-get_cpu_idle_time_us kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-add-a-comment-to-get_cpu_idle_time_us
+++ a/kernel/time/tick-sched.c
@@ -179,6 +179,20 @@ static ktime_t tick_nohz_start_idle(stru
 	return now;
 }
 
+/**
+ * get_cpu_idle_time_us - get the total idle time of a cpu
+ * @cpu: CPU number to query
+ * @last_update_time: variable to store update time in
+ *
+ * Return the cummulative idle time (since boot) for a given
+ * CPU, in microseconds. The idle time returned includes
+ * the iowait time (unlike what "top" and co report).
+ *
+ * This time is measured via accounting rather than sampling,
+ * and is as accurate as ktime_get() is.
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
_
