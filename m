Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0HIWP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51521 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab0HIWPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH tip/core/rcu 02/10] Update documentation to note the passage of INIT_RCU_HEAD()
Date: Mon,  9 Aug 2010 15:15:03 -0700
Message-Id: <1281392111-25060-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100809221447.GA24358@linux.vnet.ibm.com>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/DocBook/kernel-locking.tmpl |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index 084f6ad..e6cc574 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1725,14 +1725,6 @@ the amount of locking which needs to be done.
          if (++cache_num > MAX_CACHE_SIZE) {
                  struct object *i, *outcast = NULL;
                  list_for_each_entry(i, &amp;cache, list) {
-@@ -85,6 +94,7 @@
-         obj-&gt;popularity = 0;
-         atomic_set(&amp;obj-&gt;refcnt, 1); /* The cache holds a reference */
-         spin_lock_init(&amp;obj-&gt;lock);
-+        INIT_RCU_HEAD(&amp;obj-&gt;rcu);
-
-         spin_lock_irqsave(&amp;cache_lock, flags);
-         __cache_add(obj);
 @@ -104,12 +114,11 @@
  struct object *cache_find(int id)
  {
-- 
1.7.0.6

