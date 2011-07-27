Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1G0WFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:05:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:52957 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab1G0WFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:05:48 -0400
Date: Thu, 28 Jul 2011 00:05:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frank Rowand <frank.rowand@am.sony.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [ANNOUNCE] 3.0-rt4
In-Reply-To: <4E3089BC.1080001@am.sony.com>
Message-ID: <alpine.LFD.2.02.1107280004410.2660@ionos>
References: <alpine.LFD.2.02.1107272222420.2660@ionos> <4E3089BC.1080001@am.sony.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Frank Rowand wrote:

> On 07/27/11 14:37, Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.0-rt4 release.
> 
> ARM panda board, PREEMPT_RT_FULL
> 
> -rt3 compiled OK.  -rt4 compile fails:
> 
> 
> mm/init-mm.c:24: error: unknown field 'lock' specified in initializer
> mm/init-mm.c:24: error: unknown field 'wait_lock' specified in initializer
> mm/init-mm.c:24: error: incompatible types in initialization
> mm/init-mm.c:24: error: unknown field 'save_state' specified in initializer
> mm/init-mm.c:24: warning: excess elements in struct initializer
> mm/init-mm.c:24: warning: (near initialization for 'init_mm.context.id_lock.raw_lock')

Bah, that's what I get for trying to vanish. Fix below.

--- linux-2.6.orig/arch/arm/include/asm/mmu.h
+++ linux-2.6/arch/arm/include/asm/mmu.h
@@ -16,7 +16,7 @@ typedef struct {
 
 /* init_mm.context.id_lock should be initialized. */
 #define INIT_MM_CONTEXT(name)                                                 \
-	.context.id_lock    = __SPIN_LOCK_UNLOCKED(name.context.id_lock),
+	.context.id_lock    = __RAW_SPIN_LOCK_UNLOCKED(name.context.id_lock),
 #else
 #define ASID(mm)	(0)
 #endif


