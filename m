Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab1CXRuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:50:14 -0400
Received: from flusers.ccur.com ([173.221.59.2]:45837 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755702Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:04 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/24] jrcu: better timer slop
Message-ID: <20110324174804.GA18965@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: fix broken timer slop

The expression

	USEC_PER_SEC / (HZ * 3 / 2)

was trying to define a period, in usec, some 50% larger
than the natural HZ period.  Instead it made a period
some 30% shorter.

But such attempts are completely unnecessary.  HZ alone
works just fine.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -131,7 +131,7 @@ static struct rcu_stats {
 
 #define RCU_HZ			(20)
 #define RCU_HZ_PERIOD_US	(USEC_PER_SEC / RCU_HZ)
-#define RCU_HZ_DELTA_US		(USEC_PER_SEC / (HZ * 3 / 2))
+#define RCU_HZ_DELTA_US		(USEC_PER_SEC / HZ)
 
 static int rcu_hz = RCU_HZ;
 static int rcu_hz_period_us = RCU_HZ_PERIOD_US;
