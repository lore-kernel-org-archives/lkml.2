Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2CFQT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:19:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab2CFQTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:50 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=CZDfYd8cBUwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=koGQc5_6AAAA:8 a=r1SSx9MgkuVJm8cjJMoA:9 a=yFlQdl3_maAO-4_PlrcA:7 a=9AGU4-qqYIQA:10 a=dR6KtR_F_aoA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161946.377520329@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 07/25][RFC 3.0.23-rt39-rc1] x86: vdso: Remove bogus locking in update_vsyscall_tz()
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0007-x86-vdso-Remove-bogus-locking-in-update_vsyscall_tz.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Changing the sequence count in update_vsyscall_tz() is completely
pointless.

The vdso code copies the data unprotected. There is no point to change
this as sys_tz is nowhere protected at all. See sys_gettimeofday().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/vsyscall_64.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 0a7dc13..c378a18 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -58,12 +58,7 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 
 void update_vsyscall_tz(void)
 {
-	unsigned long flags;
-
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
-	/* sys_tz has changed */
 	vsyscall_gtod_data.sys_tz = sys_tz;
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
 void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
-- 
1.7.8.3


