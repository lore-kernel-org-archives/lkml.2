Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab0EDUYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:24:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35209 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933788Ab0EDUUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:20:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH tip/core/rcu 27/48] vfs: add fs.h to define struct file
Date: Tue,  4 May 2010 13:19:37 -0700
Message-Id: <1273004398-19760-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100504201934.GA19234@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sparse RCU-pointer annotations require definition of the
underlying type of any pointer passed to rcu_dereference() and friends.
So fcheck_files() needs "struct file" to be defined, so include fs.h.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 include/linux/fdtable.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index d147461..f59ed29 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -11,6 +11,7 @@
 #include <linux/rcupdate.h>
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/fs.h>
 
 #include <asm/atomic.h>
 
-- 
1.7.0

