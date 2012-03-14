Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082Ab2CNN3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:29:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48399 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab2CNN3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:29:47 -0400
From: "Jacquiot, Aurelien" <a-jacquiot@ti.com>
To: Mark Salter <msalter@redhat.com>, David Howells <dhowells@redhat.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: RE: [Linux-c6x-dev] [PATCH 06/35] Disintegrate asm/system.h for C6X
	[ver #2]
Thread-Topic: [Linux-c6x-dev] [PATCH 06/35] Disintegrate asm/system.h for
 C6X	[ver #2]
Thread-Index: AQHNAd4i0p2KPPGEQEeVU8LVqr3++JZpxLbw
Date: Wed, 14 Mar 2012 13:29:41 +0000
Message-ID: <553CFBBAF1315044BC4CD328C97B0B1C17FA0A76@DNCE02.ent.ti.com>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
	<20120312233706.13888.5678.stgit@warthog.procyon.org.uk>
 <1331728169.2167.2.camel@deneb.redhat.com>
In-Reply-To: <1331728169.2167.2.camel@deneb.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.131.83]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

Are you sure about the #define _ASM_C6X_BARRIER_H in exec.h? _ASM_C6X_EXEC_H sounds better...

Aurelien


Texas Instruments France SA, 821 Avenue Jack Kilby, 06270 Villeneuve Loubet. 036 420 040 R.C.S Antibes. Capital de EUR 753.920

-----Original Message-----
From: linux-c6x-dev-bounces@linux-c6x.org [mailto:linux-c6x-dev-bounces@linux-c6x.org] On Behalf Of Mark Salter
Sent: Wednesday, March 14, 2012 1:29 PM
To: David Howells
Cc: linux-arch@vger.kernel.org; linux-c6x-dev@linux-c6x.org; linux-kernel@vger.kernel.org; paul.gortmaker@windriver.com; hpa@zytor.com; torvalds@linux-foundation.org
Subject: Re: [Linux-c6x-dev] [PATCH 06/35] Disintegrate asm/system.h for C6X [ver #2]

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


_______________________________________________
Linux-c6x-dev mailing list
Linux-c6x-dev@linux-c6x.org
http://linux-c6x.org/cgi-bin/mailman/listinfo/linux-c6x-dev

