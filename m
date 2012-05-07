Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2EGAkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 20:40:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25355 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2EGAkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 20:40:07 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TtU46XPs5IkA:10 a=TRgVYD6ZyiEA:10 a=tXViLo4WAB4A:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=E5Wc86MttsPD8GMs53sA:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Sun, 06 May 2012 19:40:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] IA32 Emulation: Fix build problem after commit ce7e5d2d1
Message-ID: <4fa719e3.9iRhEn6/mKpQXtGf%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ce7e5d2d19bc ("x86: fix broken TASK_SIZE for ia32_aout") breaks kernel
builds when "CONFIG_IA32_AOUT=m" with

ERROR: "set_personality_ia32" [arch/x86/ia32/ia32_aout.ko] undefined!
make[1]: *** [__modpost] Error 1

The entry point needs to be exported.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_64.c
+++ linux-2.6/arch/x86/kernel/process_64.c
@@ -423,6 +423,7 @@ void set_personality_ia32(bool x32)
 		current_thread_info()->status |= TS_COMPAT;
 	}
 }
+EXPORT_SYMBOL_GPL(set_personality_ia32);
 
 unsigned long get_wchan(struct task_struct *p)
 {
