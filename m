Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab1FHTac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:30:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52745 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466Ab1FHTa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:29 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/28] rcu: Fix RCU's NMI documentation
Date: Wed,  8 Jun 2011 12:29:49 -0700
Message-Id: <1307561407-13809-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has long been the case that the architecture must call nmi_enter()
and nmi_exit() rather than irq_enter() and irq_exit() in order to
permit RCU read-side critical sections in NMIs.  Catch the documentation
up with reality.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/NMI-RCU.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/RCU/NMI-RCU.txt b/Documentation/RCU/NMI-RCU.txt
index a8536cb..84e4f9c 100644
--- a/Documentation/RCU/NMI-RCU.txt
+++ b/Documentation/RCU/NMI-RCU.txt
@@ -95,7 +95,7 @@ not to return until all ongoing NMI handlers exit.  It is therefore safe
 to free up the handler's data as soon as synchronize_sched() returns.
 
 Important note: for this to work, the architecture in question must
-invoke irq_enter() and irq_exit() on NMI entry and exit, respectively.
+invoke nmi_enter() and nmi_exit() on NMI entry and exit, respectively.
 
 
 Answer to Quick Quiz
-- 
1.7.3.2

