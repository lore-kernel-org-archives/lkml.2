Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab0ELVeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:34:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56553 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104Ab0ELVeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:34:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH RFC tip/core/rcu 03/23] vfs: add fs.h to define struct file
Date: Wed, 12 May 2010 14:33:22 -0700
Message-Id: <1273700022-16523-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
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
index 013dc52..551671e 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -11,6 +11,7 @@
 #include <linux/rcupdate.h>
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/fs.h>
 
 #include <asm/atomic.h>
 
-- 
1.7.0.6

