Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030575Ab2CNCbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:31:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965236Ab2CNC3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:29:47 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=Pj1Pxhdk99gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=G86Z3MZVu5vC3Y-eIz0A:9 a=8-GDt22Qt2phEVuf7xUA:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314022945.018782675@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 13 Mar 2012 22:27:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 3/7] rt: Introduce cpu_chill()
References: <20120314022658.783312660@goodmis.org>
Content-Disposition: inline; filename=0003-rt-Introduce-cpu_chill.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Retry loops on RT might loop forever when the modifying side was
preempted. Add cpu_chill() to replace cpu_relax(). cpu_chill()
defaults to cpu_relax() for non RT. On RT it puts the looping task to
sleep for a tick so the preempted task can make progress.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/delay.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index a6ecb34..e23a7c0 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -52,4 +52,10 @@ static inline void ssleep(unsigned int seconds)
 	msleep(seconds * 1000);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+# define cpu_chill()	msleep(1)
+#else
+# define cpu_chill()	cpu_relax()
+#endif
+
 #endif /* defined(_LINUX_DELAY_H) */
-- 
1.7.8.3


