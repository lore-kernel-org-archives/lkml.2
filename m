Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab0HIWP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51522 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab0HIWPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/10] Update call_rcu() usage, add synchronize_rcu()
Date: Mon,  9 Aug 2010 15:15:04 -0700
Message-Id: <1281392111-25060-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100809221447.GA24358@linux.vnet.ibm.com>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Kyle Hubert <khubert@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/DocBook/kernel-locking.tmpl |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index e6cc574..ed64d22 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1645,7 +1645,9 @@ the amount of locking which needs to be done.
       all the readers who were traversing the list when we deleted the
       element are finished.  We use <function>call_rcu()</function> to
       register a callback which will actually destroy the object once
-      the readers are finished.
+      all pre-existing readers are finished.  Alternatively,
+      <function>synchronize_rcu()</function> may be used to block until
+      all pre-existing are finished.
     </para>
     <para>
       But how does Read Copy Update know when the readers are
@@ -1714,7 +1716,7 @@ the amount of locking which needs to be done.
 -        object_put(obj);
 +        list_del_rcu(&amp;obj-&gt;list);
          cache_num--;
-+        call_rcu(&amp;obj-&gt;rcu, cache_delete_rcu, obj);
++        call_rcu(&amp;obj-&gt;rcu, cache_delete_rcu);
  }
 
  /* Must be holding cache_lock */
-- 
1.7.0.6

