Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0JRJql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:46:41 -0400
Received: from canuck.infradead.org ([134.117.69.58]:37618 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0JRJqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:46:39 -0400
Subject: Re: [sparc build bug] Re: [tip:perf/core] irq: Add tracepoint to
 softirq_raise
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
        nhorman@tuxdriver.com, scott.a.mcmillan@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        davem@davemloft.net, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, linux-tip-commits@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <20100908112529.GA25931@elte.hu>
References: <4C724298.4050509@jp.fujitsu.com>
	 <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
	 <20100908112529.GA25931@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 11:44:37 +0200
Message-ID: <1287395077.29097.1543.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 13:25 +0200, Ingo Molnar wrote:
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

I could build sparc64_defconfig, but s390 is broken for me by this...


