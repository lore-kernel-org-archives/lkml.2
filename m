Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0LFRkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:40:23 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:32031 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753960Ab0LFRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:40:19 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 7tl6.yIVM1leYPqzZiMOdQPwoIZ7wcNBVqMdG6khzGbcWYT
 elK37YBbaysvaxMOXGJuco4XkHZfaEMKkw6M.uncZA.YCMZi8lFDURXG1LXC
 3MniX37N.s8Unx4TkrnpWocqGDwnSbC2zV5xqvsUQFADZ79crnewXDlanztA
 gzysiMxuEEoJzPIRUgkirCRDZhM1UZ2O7T8bdR33E90IOhXcmLoRXTlMCPNc
 15qOrxPCt2n8m.T1WCVGYZjRIJ4RQIyvslXlYw0EL37GM6_I0zHk82if3qsK
 4qQiOMteTnDwm484uk7a8
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206174017.112009516@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:40:05 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@lst.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops inc_return V1 7/9] fs: Use this_cpu_inc_return in buffer.c
References: <20101206173958.685460926@linux.com>
Content-Disposition: inline; filename=cpuops_inc_return_buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_inc can create a single instruction with the same effect
as the _get_cpu_var(..)++ construct in buffer.c.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2010-12-06 10:56:21.000000000 -0600
+++ linux-2.6/fs/buffer.c	2010-12-06 10:56:26.000000000 -0600
@@ -3201,7 +3201,7 @@ static void recalc_bh_state(void)
 	int i;
 	int tot = 0;
 
-	if (__get_cpu_var(bh_accounting).ratelimit++ < 4096)
+	if (__this_cpu_inc_return(bh_accounting.ratelimit) - 1 < 4096)
 		return;
 	__this_cpu_write(bh_accounting.ratelimit, 0);
 	for_each_online_cpu(i)

