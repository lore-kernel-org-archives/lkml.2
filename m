Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2JIHSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:18:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35125 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2JIHSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:18:45 -0400
Date: Tue, 9 Oct 2012 10:18:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] time: cast ->raw_interval to u64 to avoid shift overflow
Message-ID: <20121009071823.GA19159@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fixed a bunch of integer overflows in timekeeping code during the 3.6
cycle.  I did an audit based on that and found this potential overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I'm not super familiar with this code so please review my work
carefully.

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5ce06a3..1d1ee67 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1113,7 +1113,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	accumulate_nsecs_to_secs(tk);
 
 	/* Accumulate raw time */
-	raw_nsecs = tk->raw_interval << shift;
+	raw_nsecs = (u64)tk->raw_interval << shift;
 	raw_nsecs += tk->raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;
