Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab2HWRoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:44:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54790 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2HWRoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:44:00 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 23:13:59 +0530
Message-ID: <CADArhcA1CHE-_Z+zg9bEgD5EwR56PZ+wesGc_=DcJ3LvCdKoTA@mail.gmail.com>
Subject: [PATCH] kprobes: *ap before *op otherwise ap pointer will be Dangling
From: Akhilesh Kumar <akhilesh.lxr@gmail.com>
To: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a77438899c7295299b59edca8d1816ea70d6ed8e Mon Sep 17 00:00:00 2001
From: Akhilesh Kumar <akhilesh.lxr@gmail.com>
Date: Fri, 23 Aug 2012 23:02:07 +0530
Subject:[PATCH] kprobes: *ap before *op otherwise ap pointer will be Dangling

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
