Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab2JJO1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:27:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab2JJO1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:27:53 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tostatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] x86, add hypervisor name to dump_stack()
Date: Wed, 10 Oct 2012 10:27:48 -0400
Message-Id: <1349879268-3573-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging crash, panics, stack trace WARN_ONs, etc., from both virtual and
bare-metal boots can get difficult very quickly.  While there are ways to
decipher the output and determine if the output is from a virtual guest,
the in-kernel hypervisors now have a single registration point and set
x86_hyper.  We can use this to output a single extra line on virtual
machines that indicates the hypervisor type.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Marcelo Tostatti <mtosatti@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: kvm@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/kernel/dumpstack.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index ae42418b..75a635e 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -17,6 +17,7 @@
 #include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
+#include <asm/hypervisor.h>
 
 
 int panic_on_unrecovered_nmi;
@@ -193,6 +194,8 @@ void dump_stack(void)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
+	if (x86_hyper && x86_hyper->name)
+		printk("Hypervisor: %s\n",  x86_hyper->name);
 	show_trace(NULL, NULL, &stack, bp);
 }
 EXPORT_SYMBOL(dump_stack);
-- 
1.7.9.3

