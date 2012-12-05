Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2LESrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:47:51 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:41145 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2LESo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:44:56 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 03/10] CPU hotplug: Convert preprocessor macros to
 static inline functions
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 00:13:28 +0530
Message-ID: <20121205184326.3750.97473.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com>
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120518-5816-0000-0000-000005B2BD17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 06:10 AM, Andrew Morton wrote:
"static inline C functions would be preferred if possible.  Feel free to
fix up the wrong crufty surrounding code as well ;-)"

Convert the macros in the CPU hotplug code to static inline C functions.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index e2a9c49..599b376 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -200,12 +200,12 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #else		/* CONFIG_HOTPLUG_CPU */
 
-#define get_online_cpus()	do { } while (0)
-#define put_online_cpus()	do { } while (0)
-#define get_online_cpus_atomic_light()	do { } while (0)
-#define put_online_cpus_atomic_light()	do { } while (0)
-#define get_online_cpus_atomic_full()	do { } while (0)
-#define put_online_cpus_atomic_full()	do { } while (0)
+static inline void get_online_cpus(void) {}
+static inline void put_online_cpus(void) {}
+static inline void get_online_cpus_atomic_light(void) {}
+static inline void put_online_cpus_atomic_light(void) {}
+static inline void get_online_cpus_atomic_full(void) {}
+static inline void put_online_cpus_atomic_full(void) {}
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })

