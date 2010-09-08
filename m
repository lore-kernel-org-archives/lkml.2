Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab0IHL0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 07:26:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52986 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab0IHL0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 07:26:07 -0400
Date: Wed, 8 Sep 2010 13:25:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
        nhorman@tuxdriver.com, scott.a.mcmillan@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        davem@davemloft.net, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com
Cc: linux-tip-commits@vger.kernel.org
Subject: [sparc build bug] Re: [tip:perf/core] irq: Add tracepoint to
 softirq_raise
Message-ID: <20100908112529.GA25931@elte.hu>
References: <4C724298.4050509@jp.fujitsu.com>
 <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Commit-ID:  2bf2160d8805de64308e2e7c3cd97813cb58ed2f
> Gitweb:     http://git.kernel.org/tip/2bf2160d8805de64308e2e7c3cd97813cb58ed2f
> Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
> AuthorDate: Mon, 23 Aug 2010 18:42:48 +0900
> Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> CommitDate: Tue, 7 Sep 2010 17:49:34 +0200
> 
> irq: Add tracepoint to softirq_raise
> 
> Add a tracepoint for tracing when softirq action is raised.
> 
> This and the existing tracepoints complete softirq's tracepoints:
> softirq_raise, softirq_entry and softirq_exit.
> 
> And when this tracepoint is used in combination with
> the softirq_entry tracepoint we can determine
> the softirq raise latency.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Kaneshige Kenji <kaneshige.kenji@jp.fujitsu.com>
> Cc: Izumo Taku <izumi.taku@jp.fujitsu.com>
> Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Scott Mcmillan <scott.a.mcmillan@intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> LKML-Reference: <4C724298.4050509@jp.fujitsu.com>
> [ factorize softirq events with DECLARE_EVENT_CLASS ]
> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/interrupt.h  |    8 +++++++-
>  include/trace/events/irq.h |   26 ++++++++++++++++++++++++--
>  2 files changed, 31 insertions(+), 3 deletions(-)

FYI, this commit broke the Sparc build:

In file included from /home/mingo/tip/arch/sparc/include/asm/irq_32.h:11,
                 from /home/mingo/tip/arch/sparc/include/asm/irq.h:6,
                 from /home/mingo/tip/include/linux/irqnr.h:10,
                 from /home/mingo/tip/include/linux/irq.h:22,
                 from /home/mingo/tip/include/asm-generic/hardirq.h:6,
                 from /home/mingo/tip/arch/sparc/include/asm/hardirq_32.h:11,
                 from /home/mingo/tip/arch/sparc/include/asm/hardirq.h:6,
                 from /home/mingo/tip/include/linux/hardirq.h:10,
                 from /home/mingo/tip/include/linux/ftrace_event.h:7,
                 from /home/mingo/tip/include/trace/syscall.h:6,
                 from /home/mingo/tip/include/linux/syscalls.h:76,
                 from /home/mingo/tip/init/initramfs.c:9:
/home/mingo/tip/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
/home/mingo/tip/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
/home/mingo/tip/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
make[2]: *** [init/initramfs.o] Error 1
make[2]: *** Waiting for unfinished jobs....
In file included from /home/mingo/tip/arch/sparc/include/asm/irq_32.h:11,

	Ingo
