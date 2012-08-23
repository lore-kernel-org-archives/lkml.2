Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2HWRFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:05:36 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61032 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2HWRFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:05:33 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 22:35:32 +0530
Message-ID: <CAG6PDMa6OR4eqckoUwuHcv7om2j5qsYx9mPx4_Z+Bzr8nxaMLA@mail.gmail.com>
Subject: [Memory Leak] free kprobe before optimized_kprobe free
From: akhilesh kumar <kumarakhilesh479@gmail.com>
To: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a77438899c7295299b59cdca8d1816ea69d6ed8e Mon Sep 17 00:00:00 2001
From: Akhilesh Kumar <akhilesh.lxr@gmail.com>
Date: Fri, 10 Aug 2012 14:02:07 +0530
Subject:[Memory Leak] free kprobe before optimized_kprobe free

Free *ap before *op otherwise ap pointer will be Dangling

Signed-off-by: Akhilesh Kumar <akhilesh.lxr@gmail.com>
---
 kernel/kprobes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..ff0a97b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -767,6 +767,7 @@ static __kprobes void
try_to_optimize_kprobe(struct kprobe *p)
 	if (!arch_prepared_optinsn(&op->optinsn)) {
 		/* If failed to setup optimizing, fallback to kprobe */
 		arch_remove_optimized_kprobe(op);
+		kfree(ap);
 		kfree(op);
 		return;
 	}
-- 
1.7.8.4
