Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab1BANwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:17 -0500
Received: from www.tglx.de ([62.245.132.106]:47302 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab1BANwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:15 -0500
Message-Id: <20110201134418.326209775@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 09/28] thread_info: Remove legacy arg0-3 from restart_block
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=thread-info-remove-arg0-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

posix timers were the last users of the legacy arg0-3 members of
restart_block. Remove the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/thread_info.h |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6-tip/include/linux/thread_info.h
===================================================================
--- linux-2.6-tip.orig/include/linux/thread_info.h
+++ linux-2.6-tip/include/linux/thread_info.h
@@ -18,9 +18,6 @@ struct compat_timespec;
 struct restart_block {
 	long (*fn)(struct restart_block *);
 	union {
-		struct {
-			unsigned long arg0, arg1, arg2, arg3;
-		};
 		/* For futex_wait and futex_wait_requeue_pi */
 		struct {
 			u32 __user *uaddr;


