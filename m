Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0FYNFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:05:23 -0400
Received: from ozlabs.org ([203.10.76.45]:38817 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0FYNFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:05:22 -0400
To: Ingo Molnar <mingo@elte.hu>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <201006252235.16647.rusty@rustcorp.com.au>
Date: Fri, 25 Jun 2010 22:35:15 +0930
Subject: [PATCH 5/5] cpumask: reduce cpumask_size
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       anton@samba.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>
Cc: anton@samba.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we're sure noone is using old cpumask operators, nor *cpumask, we can
allocate less bits safely.  This reduces the memory usage of off-stack
cpumasks when CONFIG_CPUMASK_OFFSTACK=y but we don't have NR_CPUS actual
cpus.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: anton@samba.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -1014,13 +1014,11 @@ static inline int cpulist_parse(const ch
 /**
  * cpumask_size - size to allocate for a 'struct cpumask' in bytes
  *
- * This will eventually be a runtime variable, depending on nr_cpu_ids.
+ * This can be a runtime variable, depending on nr_cpu_ids.
  */
 static inline size_t cpumask_size(void)
 {
-	/* FIXME: Once all cpumask assignments are eliminated, this
-	 * can be nr_cpumask_bits */
-	return BITS_TO_LONGS(NR_CPUS) * sizeof(long);
+	return BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long);
 }
 
 /*

