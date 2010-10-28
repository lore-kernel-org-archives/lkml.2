Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab0J1N5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:57:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab0J1N4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:56:50 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=_619Z5J5yZAA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=rC0RDAs1UfCYcENPbA4A:9 a=rpW6oZYATrJTlR8l3WQA:7 a=5fegoeVxwPKyembgklqSWpUD19gA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101028135648.944178348@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Oct 2010 09:55:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 8/8] jump label: Disable due to compiler bug
References: <20101028135548.055490014@goodmis.org>
Content-Disposition: inline; filename=0008-jump-label-Disable-due-to-compiler-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Unfortunately, we found a compiler bug in the implementation of
'asm goto'. The bug can cause the kernel to crash.

For now, we are disabling jump labels with a big hammer. When the
gcc fix is committed, we will update the kernel with a better check
for either the version number it's fix in, or some detection of
whether gcc has the fix in place.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/jump_label.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index b3835f6..d9d367c 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -1,11 +1,20 @@
 #ifndef _LINUX_JUMP_LABEL_H
 #define _LINUX_JUMP_LABEL_H
 
+/*
+ * A compiler bug was found in the implementation of 'asm goto'. Thus,
+ * we are disabling it for now pending a better check for compiler version
+ * that fixes it.
+ */
+#if 0
+
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif
 
+#endif
+
 enum jump_label_type {
 	JUMP_LABEL_ENABLE,
 	JUMP_LABEL_DISABLE
-- 
1.7.1


