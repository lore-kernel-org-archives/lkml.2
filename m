Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986Ab0EDUX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:23:26 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41832 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933797Ab0EDUUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:20:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH tip/core/rcu 41/48] idr: __rcu annotations
Date: Tue,  4 May 2010 13:19:51 -0700
Message-Id: <1273004398-19760-41-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100504201934.GA19234@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/idr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index e968db7..cdb715e 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -50,14 +50,14 @@
 
 struct idr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
-	struct idr_layer	*ary[1<<IDR_BITS];
+	struct idr_layer __rcu	*ary[1<<IDR_BITS];
 	int			 count;	 /* When zero, we can release it */
 	int			 layer;	 /* distance from leaf */
 	struct rcu_head		 rcu_head;
 };
 
 struct idr {
-	struct idr_layer *top;
+	struct idr_layer __rcu *top;
 	struct idr_layer *id_free;
 	int		  layers; /* only valid without concurrent changes */
 	int		  id_free_cnt;
-- 
1.7.0

