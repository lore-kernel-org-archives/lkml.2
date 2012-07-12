Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162641Ab2GLXUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:20:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17423 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162569Ab2GLXT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:19:58 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=ORyw_0ESD5gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=D_SbEOMbAAAA:8 a=Ri-2UK2ZMocrydySKJQA:9 a=7KbvKZvEaC0A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120712231956.179265047@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Jul 2012 19:18:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 3/8] Disable RT_GROUP_SCHED in PREEMPT_RT_FULL
References: <20120712231827.084920483@goodmis.org>
Content-Disposition: inline; filename=0003-Disable-RT_GROUP_SCHED-in-PREEMPT_RT_FULL.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <C.Emde@osadl.org>

Strange CPU stalls have been observed in RT when RT_GROUP_SCHED
was configured.

Disable it for now.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index dbc82d0..720c182 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -731,6 +731,7 @@ config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
 	depends on EXPERIMENTAL
 	depends on CGROUP_SCHED
+	depends on !PREEMPT_RT_FULL
 	default n
 	help
 	  This feature lets you explicitly allocate real CPU bandwidth
-- 
1.7.10.4


