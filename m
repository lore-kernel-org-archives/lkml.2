Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab2CATDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:03:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2CATDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:03:47 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=L6aY_HCc1soA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=63-PBQ9K5Humy5ROcUUA:9 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120301190345.786365803@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 01 Mar 2012 13:55:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT 5/9][RFC] [PATCH 5/9] ring-buffer/rt: Check for irqs disabled before grabbing reader lock
References: <20120301185527.064629423@goodmis.org>
Content-Disposition: inline; filename=0005-ring-buffer-rt-Check-for-irqs-disabled-before-grabbi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In RT the reader lock is a mutex and we can not grab it when preemption is
disabled. The in_atomic() check that is there does not check if irqs are
disabled. Add that check as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 354017f..c060f04 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1054,7 +1054,7 @@ static inline int ok_to_lock(void)
 	if (in_nmi())
 		return 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
-	if (in_atomic())
+	if (in_atomic() || irqs_disabled())
 		return 0;
 #endif
 	return 1;
-- 
1.7.3.4


