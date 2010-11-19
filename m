Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0KSF1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:27:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34196 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab0KSF1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:27:08 -0500
From: Anand Gadiyar <gadiyar@ti.com>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: Anand Gadiyar <gadiyar@ti.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] kernel/cpu.c - fix build warning
Date: Fri, 19 Nov 2010 10:56:50 +0530
Message-Id: <1290144410-30981-1-git-send-email-gadiyar@ti.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch "sched: Simplify cpu-hot-unplug task migration" in
linux-next as of 20101119 introduced the following compile
warning. Fix this.

  CC      kernel/cpu.o
kernel/cpu.c: In function 'take_cpu_down':
kernel/cpu.c:200: warning: unused variable 'cpu'

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
Okay with me to fold this into the original patch if that's
still possible.

 kernel/cpu.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -197,7 +197,6 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
-	unsigned int cpu = (unsigned long)param->hcpu;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
