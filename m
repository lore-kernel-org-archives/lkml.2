Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0J0VIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340Ab0J0VHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:07:51 -0400
Date: Wed, 27 Oct 2010 17:07:17 -0400
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org, mingo@elte.hu
Cc: mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, ddaney@caviumnetworks.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Message-Id: <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>
In-Reply-To: <cover.1288212485.git.jbaron@redhat.com>
References: <cover.1288212485.git.jbaron@redhat.com>
Subject: [PATCH 2/2] jump label: disable due to compiler bug
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, we found a compiler bug in the implementation of
'asm goto'. The bug can cause the kernel to crash.

For now, we are disabling jump labels with a big hammer. When the
gcc fix is committed, we will update the kernel with a better check
for either the version number it's fix in, or some detection of
whether gcc has the fix in place.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/jump_label.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index b67cb18..954462a 100644
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

