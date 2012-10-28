Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2J1XdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:33:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42207 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757022Ab2J1X21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:27 -0400
Message-Id: <20121028231546.844813930@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:08 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 032/105] timekeeping: Cast raw_interval to u64 to avoid shift overflow
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 5b3900cd409466c0070b234d941650685ad0c791 upstream.

We fixed a bunch of integer overflows in timekeeping code during the 3.6
cycle.  I did an audit based on that and found this potential overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/20121009071823.GA19159@elgon.mountain
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.2: adjust context; use timekeeper.raw_interval]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -992,7 +992,7 @@ static cycle_t logarithmic_accumulation(
 	}
 
 	/* Accumulate raw time */
-	raw_nsecs = timekeeper.raw_interval << shift;
+	raw_nsecs = (u64)timekeeper.raw_interval << shift;
 	raw_nsecs += raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;


