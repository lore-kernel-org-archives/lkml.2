Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab1KOU23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:28:29 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52436 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab1KOU21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:28:27 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/9] rcu: Control rcutorture startup from kernel boot parameters
Date: Tue, 15 Nov 2011 12:27:59 -0800
Message-Id: <1321388885-11211-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111115202736.GA11030@linux.vnet.ibm.com>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
x-cbid: 11111520-5112-0000-0000-00000210704B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Currently, if rcutorture is built into the kernel, it must be manually
started or started from an init script.  This is inconvenient for
automated KVM testing, where it is good to be able to fully control
rcutorture execution from the kernel parameters.  This patch therefore
adds a module parameter named "rcutorture_runnable" that defaults
to zero ("don't start automatically"), but which can be set to one
to cause rcutorture to start up immediately during boot.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 41802be..fd7a0e6 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -164,6 +164,8 @@ static int stutter_pause_test;
 #define RCUTORTURE_RUNNABLE_INIT 0
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
+module_param(rcutorture_runnable, int, 0444);
+MODULE_PARM_DESC(rcutorture_runnable, "Start rcutorture at boot");
 
 #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU)
 #define rcu_can_boost() 1
-- 
1.7.3.2

