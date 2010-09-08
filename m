Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab0IHMZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:25:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44315 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab0IHMZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T3lK0YgmgRK7qcdXkFJZ0nnc/MNQLlgtS+CAHjaf1yStvKWgn52VwcBGC61Qi5of7l
         mnSu8IDblNB1XwfziD3QTEDBZ0MUsLY/9JJ7yZPScEPtEdSk+jkbLjPBJsh3X0aBgDCz
         OqaeI4idOYLwvcMd8aC11P2aPz8PDu2XWqd5U=
Date: Wed, 8 Sep 2010 14:26:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, rostedt@goodmis.org, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, davem@davemloft.net,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        linux-tip-commits@vger.kernel.org
Subject: [PATCH] irq: Fix circular headers dependency
Message-ID: <20100908122557.GA5310@nowhere>
References: <4C724298.4050509@jp.fujitsu.com> <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org> <20100908112529.GA25931@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908112529.GA25931@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 01:25:29PM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > Commit-ID:  2bf2160d8805de64308e2e7c3cd97813cb58ed2f
> > Gitweb:     http://git.kernel.org/tip/2bf2160d8805de64308e2e7c3cd97813cb58ed2f
> > Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
> > AuthorDate: Mon, 23 Aug 2010 18:42:48 +0900
> > Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> > CommitDate: Tue, 7 Sep 2010 17:49:34 +0200
> > 
> > irq: Add tracepoint to softirq_raise
> > 
> > Add a tracepoint for tracing when softirq action is raised.
> > 
> > This and the existing tracepoints complete softirq's tracepoints:
> > softirq_raise, softirq_entry and softirq_exit.
> > 
> > And when this tracepoint is used in combination with
> > the softirq_entry tracepoint we can determine
> > the softirq raise latency.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Kaneshige Kenji <kaneshige.kenji@jp.fujitsu.com>
> > Cc: Izumo Taku <izumi.taku@jp.fujitsu.com>
> > Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Scott Mcmillan <scott.a.mcmillan@intel.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > LKML-Reference: <4C724298.4050509@jp.fujitsu.com>
> > [ factorize softirq events with DECLARE_EVENT_CLASS ]
> > Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  include/linux/interrupt.h  |    8 +++++++-
> >  include/trace/events/irq.h |   26 ++++++++++++++++++++++++--
> >  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> FYI, this commit broke the Sparc build:
> 
> In file included from /home/mingo/tip/arch/sparc/include/asm/irq_32.h:11,
>                  from /home/mingo/tip/arch/sparc/include/asm/irq.h:6,
>                  from /home/mingo/tip/include/linux/irqnr.h:10,
>                  from /home/mingo/tip/include/linux/irq.h:22,
>                  from /home/mingo/tip/include/asm-generic/hardirq.h:6,
>                  from /home/mingo/tip/arch/sparc/include/asm/hardirq_32.h:11,
>                  from /home/mingo/tip/arch/sparc/include/asm/hardirq.h:6,
>                  from /home/mingo/tip/include/linux/hardirq.h:10,
>                  from /home/mingo/tip/include/linux/ftrace_event.h:7,
>                  from /home/mingo/tip/include/trace/syscall.h:6,
>                  from /home/mingo/tip/include/linux/syscalls.h:76,
>                  from /home/mingo/tip/init/initramfs.c:9:
> /home/mingo/tip/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
> /home/mingo/tip/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
> /home/mingo/tip/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
> make[2]: *** [init/initramfs.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> In file included from /home/mingo/tip/arch/sparc/include/asm/irq_32.h:11,
> 
> 	Ingo


Yeah, there is a circular dependency.
Does that fixes the issue (and if so, does that look sane)?

Thanks.

---
>From fc21eaa02d4a6f0af396af6a106587e61515cd86 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 8 Sep 2010 14:17:31 +0200
Subject: [PATCH] irq: Fix circular headers dependency

asm-generic/hardirq.h needs asm/irq.h which might include
linux/interrupt.h as in the sparc 32 case. At this point
we need irq_cpustat generic definitions, but those are
included later in asm-generic/hardirq.h.

Then delay a bit the inclusion of irq.h from
asm-generic/hardirq.h, it doesn't need to be included early.

This fixes:

In file included from arch/sparc/include/asm/irq_32.h:11,
                  from arch/sparc/include/asm/irq.h:6,
                  from include/linux/irqnr.h:10,
                  from include/linux/irq.h:22,
                  from include/asm-generic/hardirq.h:6,
                  from arch/sparc/include/asm/hardirq_32.h:11,
                  from arch/sparc/include/asm/hardirq.h:6,
                  from include/linux/hardirq.h:10,
                  from include/linux/ftrace_event.h:7,
                  from include/trace/syscall.h:6,
                  from include/linux/syscalls.h:76,
                  from init/initramfs.c:9:
include/linux/interrupt.h: In function '__raise_softirq_irqoff':
include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
include/linux/interrupt.h:414: error: lvalue required as left operand of assignment

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
---
 include/asm-generic/hardirq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
index 62f5908..04d0a97 100644
--- a/include/asm-generic/hardirq.h
+++ b/include/asm-generic/hardirq.h
@@ -3,13 +3,13 @@
 
 #include <linux/cache.h>
 #include <linux/threads.h>
-#include <linux/irq.h>
 
 typedef struct {
 	unsigned int __softirq_pending;
 } ____cacheline_aligned irq_cpustat_t;
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+#include <linux/irq.h>
 
 #ifndef ack_bad_irq
 static inline void ack_bad_irq(unsigned int irq)
-- 
1.6.2.3


