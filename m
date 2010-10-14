Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0JNDIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 23:08:20 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36843 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0JNDIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 23:08:18 -0400
X-AuditID: b753bd60-a98ddba000000a18-53-4cb6741f0061
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  3/5] Define __stop_machine when CONFIG_STOP_MACHINE=n
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Oct 2010 12:10:30 +0900
Message-ID: <20101014031030.4100.34156.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define dummy __stop_machine() function even when CONFIG_STOP_MACHINE=n.
This getcpu-required version of stop_machine() will be used from
poke_text_smp().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
---

 include/linux/stop_machine.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 6b524a0..1808960 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -126,8 +126,8 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
 #else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
 
-static inline int stop_machine(int (*fn)(void *), void *data,
-			       const struct cpumask *cpus)
+static inline int __stop_machine(int (*fn)(void *), void *data,
+				 const struct cpumask *cpus)
 {
 	int ret;
 	local_irq_disable();
@@ -136,5 +136,11 @@ static inline int stop_machine(int (*fn)(void *), void *data,
 	return ret;
 }
 
+static inline int stop_machine(int (*fn)(void *), void *data,
+			       const struct cpumask *cpus)
+{
+	return __stop_machine(fn, data, cpus);
+}
+
 #endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */

