Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab0J0XCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:02:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44993 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab0J0XCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:02:32 -0400
X-User-Agent: K-9 Mail for Android
References: <cover.1288212485.git.jbaron@redhat.com> <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>
In-Reply-To: <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 27 Oct 2010 15:21:55 -0700
To: Jason Baron <jbaron@redhat.com>, rostedt@goodmis.org, mingo@elte.hu
CC: mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        ddaney@caviumnetworks.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Message-ID: <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you detail the bug, please?  static_cpu_has() also uses asm goto.

"Jason Baron" <jbaron@redhat.com> wrote:

>Unfortunately, we found a compiler bug in the implementation of
>'asm goto'. The bug can cause the kernel to crash.
>
>For now, we are disabling jump labels with a big hammer. When the
>gcc fix is committed, we will update the kernel with a better check
>for either the version number it's fix in, or some detection of
>whether gcc has the fix in place.
>
>Signed-off-by: Jason Baron <jbaron@redhat.com>
>---
> include/linux/jump_label.h |    9 +++++++++
> 1 files changed, 9 insertions(+), 0 deletions(-)
>
>diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
>index b67cb18..954462a 100644
>--- a/include/linux/jump_label.h
>+++ b/include/linux/jump_label.h
>@@ -1,11 +1,20 @@
> #ifndef _LINUX_JUMP_LABEL_H
> #define _LINUX_JUMP_LABEL_H
> 
>+/*
>+ * A compiler bug was found in the implementation of 'asm goto'. Thus,
>+ * we are disabling it for now pending a better check for compiler
>version
>+ * that fixes it.
>+ */
>+#if 0
>+
> #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
> # include <asm/jump_label.h>
> # define HAVE_JUMP_LABEL
> #endif
> 
>+#endif
>+
> enum jump_label_type {
> 	JUMP_LABEL_ENABLE,
> 	JUMP_LABEL_DISABLE
>-- 
>1.7.1

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
