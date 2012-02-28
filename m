Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030413Ab2B1UlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:41:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43569 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab2B1UlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:41:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.137.15 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH] percpu: fix __this_cpu_{sub,inc,dec}_return() definition
To: Tejun Heo <tj@kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org,
        Torsten Kaiser <just.for.lkml@googlemail.com>
Date: Wed, 29 Feb 2012 00:41:12 +0400
Message-ID: <20120228204112.7816.24302.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missed "__" prefixes, otherwise these functions
works as irq/preemption safe.

Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/percpu.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 5903f73..2b9f82c 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -668,9 +668,9 @@ do {									\
 	__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val)
 #endif
 
-#define __this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
-#define __this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
-#define __this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
+#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(val))
+#define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
+#define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
 
 #define __this_cpu_generic_xchg(pcp, nval)				\
 ({	typeof(pcp) ret__;						\

