Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920Ab2CNMaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:30:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab2CNM3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:29:35 -0400
Subject: Re: [PATCH 06/35] Disintegrate asm/system.h for C6X [ver #2]
From: Mark Salter <msalter@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        arnd@arndb.de, linux-c6x-dev@linux-c6x.org
Date: Wed, 14 Mar 2012 08:29:27 -0400
In-Reply-To: <20120312233706.13888.5678.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
	 <20120312233706.13888.5678.stgit@warthog.procyon.org.uk>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1331728169.2167.2.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 23:37 +0000, David Howells wrote:
> Disintegrate asm/system.h for C6X.  Not compiled.  Appears to be missing
> asm/atomic.h and asm/bug.h.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-c6x-dev@linux-c6x.org
> ---

I needed the following to clean up build errors from this:

diff --git a/arch/c6x/include/asm/bug.h b/arch/c6x/include/asm/bug.h
index 3df21c0..8d59933 100644
--- a/arch/c6x/include/asm/bug.h
+++ b/arch/c6x/include/asm/bug.h
@@ -11,11 +11,13 @@
 #ifndef _ASM_C6X_BUG_H
 #define _ASM_C6X_BUG_H
 
+#include <linux/linkage.h>
 #include <asm-generic/bug.h>
 
 struct pt_regs;
 
 extern void die(char *str, struct pt_regs *fp, int nr);
 extern asmlinkage int process_exception(struct pt_regs *regs);
+extern asmlinkage void enable_exception(void);
 
 #endif /* _ASM_C6X_BUG_H */
diff --git a/arch/c6x/include/asm/exec.h b/arch/c6x/include/asm/exec.h
new file mode 100644
index 0000000..646b5b7
--- /dev/null
+++ b/arch/c6x/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_BARRIER_H
+#define _ASM_C6X_BARRIER_H
+
+#define arch_align_stack(x) (x)
+
+#endif
diff --git a/arch/c6x/include/asm/special_insns.h b/arch/c6x/include/asm/special_insns.h
index 3be40df..59672bc 100644
--- a/arch/c6x/include/asm/special_insns.h
+++ b/arch/c6x/include/asm/special_insns.h
@@ -48,7 +48,6 @@
 /*
  * Exception management
  */
-asmlinkage void enable_exception(void);
 #define disable_exception()
 #define get_except_type()        get_creg(EFR)
 #define ack_exception(type)      set_creg(ECR, 1 << (type))
diff --git a/arch/c6x/include/asm/switch_to.h b/arch/c6x/include/asm/switch_to.h
index 83bb5a4..af6c71f 100644
--- a/arch/c6x/include/asm/switch_to.h
+++ b/arch/c6x/include/asm/switch_to.h
@@ -11,6 +11,8 @@
 #ifndef _ASM_C6X_SWITCH_TO_H
 #define _ASM_C6X_SWITCH_TO_H
 
+#include <linux/linkage.h>
+
 #define prepare_to_switch()    do { } while (0)
 
 struct task_struct;


