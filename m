Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030593Ab2CNMgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:36:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760910Ab2CNMgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:36:01 -0400
Subject: Re: [PATCH 34/35] Remove all #inclusions of asm/system.h [ver #2]
From: Mark Salter <msalter@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        arnd@arndb.de
Date: Wed, 14 Mar 2012 08:35:57 -0400
In-Reply-To: <20120312234153.13888.99296.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
	 <20120312234153.13888.99296.stgit@warthog.procyon.org.uk>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1331728558.2167.5.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 23:41 +0000, David Howells wrote:
> Remove all #inclusions of asm/system.h preparatory to splitting and
> killing
> it.  Performed with the following command:
> 
> perl -p -i -e 's!^#\s*include\s*<asm/system[.]h>.*\n!!' `grep -Irl '^#
> \s*include\s*<asm/system[.]h>' *`

I needed the following to clean up C6X build errors from this one:

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 6ec0ba4..1ced641 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -15,6 +15,8 @@
 #ifndef __ASM_GENERIC_ATOMIC_H
 #define __ASM_GENERIC_ATOMIC_H
 
+#include <asm/cmpxchg.h>
+
 #ifdef CONFIG_SMP
 /* Force people to define core atomics */
 # if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
diff --git a/arch/c6x/kernel/irq.c b/arch/c6x/kernel/irq.c
index 0929e4b..f8a5af2 100644
--- a/arch/c6x/kernel/irq.c
+++ b/arch/c6x/kernel/irq.c
@@ -27,6 +27,7 @@
 #include <linux/kernel_stat.h>
 
 #include <asm/megamod-pic.h>
+#include <asm/special_insns.h>
 
 unsigned long irq_err_count;
 
diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
index 0c07921..ce46186 100644
--- a/arch/c6x/kernel/setup.c
+++ b/arch/c6x/kernel/setup.c
@@ -34,6 +34,7 @@
 #include <asm/dscr.h>
 #include <asm/clock.h>
 #include <asm/soc.h>
+#include <asm/special_insns.h>
 
 static const char *c6x_soc_name;
 
diff --git a/arch/c6x/kernel/time.c b/arch/c6x/kernel/time.c
index 4c9f136..356ee84 100644
--- a/arch/c6x/kernel/time.c
+++ b/arch/c6x/kernel/time.c
@@ -20,6 +20,7 @@
 #include <linux/timex.h>
 #include <linux/profile.h>
 
+#include <asm/special_insns.h>
 #include <asm/timer64.h>
 
 static u32 sched_clock_multiplier;
diff --git a/arch/c6x/kernel/traps.c b/arch/c6x/kernel/traps.c
index f50e3ed..1be74e5 100644
--- a/arch/c6x/kernel/traps.c
+++ b/arch/c6x/kernel/traps.c
@@ -14,6 +14,7 @@
 #include <linux/bug.h>
 
 #include <asm/soc.h>
+#include <asm/special_insns.h>
 #include <asm/traps.h>
 
 int (*c6x_nmi_handler)(struct pt_regs *regs);
diff --git a/arch/c6x/platforms/timer64.c b/arch/c6x/platforms/timer64.c
index 03c03c2..3c73d74 100644
--- a/arch/c6x/platforms/timer64.c
+++ b/arch/c6x/platforms/timer64.c
@@ -15,6 +15,7 @@
 #include <linux/of_address.h>
 #include <asm/soc.h>
 #include <asm/dscr.h>
+#include <asm/special_insns.h>
 #include <asm/timer64.h>
 
 struct timer_regs {


