Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992856Ab2K3TBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:01:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:58678 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992830Ab2K3S4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [ 54/56] timekeeping: Cast raw_interval to u64 to avoid shift overflow
Date: Fri, 30 Nov 2012 10:55:46 -0800
Message-Id: <20121130185123.818857217@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 5b3900cd409466c0070b234d941650685ad0c791 upstream.

We fixed a bunch of integer overflows in timekeeping code during the 3.6
cycle.  I did an audit based on that and found this potential overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/20121009071823.GA19159@elgon.mountain
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ herton: adapt for 3.5, timekeeper instead of tk pointer ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1014,7 +1014,7 @@ static cycle_t logarithmic_accumulation(
 	}
 
 	/* Accumulate raw time */
-	raw_nsecs = timekeeper.raw_interval << shift;
+	raw_nsecs = (u64)timekeeper.raw_interval << shift;
 	raw_nsecs += timekeeper.raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;


