Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab0JSK7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:59:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49654 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab0JSK7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:59:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CBD79CF.2060706@jp.fujitsu.com>
Date: Tue, 19 Oct 2010 19:58:23 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, mathieu.desnoyers@efficios.com,
        fweisbec@gmail.com, rostedt@goodmis.org, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, davem@davemloft.net,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        linux-tip-commits@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [sparc build bug] Re: [tip:perf/core] irq: Add tracepoint to
 softirq_raise
References: <4C724298.4050509@jp.fujitsu.com>	 <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>	 <20100908112529.GA25931@elte.hu>  <1287395077.29097.1543.camel@twins> <1287398936.29097.1548.camel@twins>
In-Reply-To: <1287398936.29097.1548.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/18 19:48), Peter Zijlstra wrote:
> On Mon, 2010-10-18 at 11:44 +0200, Peter Zijlstra wrote:
>> On Wed, 2010-09-08 at 13:25 +0200, Ingo Molnar wrote:
>>> * tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>>
>>>> Commit-ID:  2bf2160d8805de64308e2e7c3cd97813cb58ed2f
>>>> Gitweb:     http://git.kernel.org/tip/2bf2160d8805de64308e2e7c3cd97813cb58ed2f
>>>> Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
>>>> AuthorDate: Mon, 23 Aug 2010 18:42:48 +0900
>>>> Committer:  Frederic Weisbecker <fweisbec@gmail.com>
>>>> CommitDate: Tue, 7 Sep 2010 17:49:34 +0200
>>>>
>>>> irq: Add tracepoint to softirq_raise
>>>>
>>>> Add a tracepoint for tracing when softirq action is raised.
>>>>
>>>> This and the existing tracepoints complete softirq's tracepoints:
>>>> softirq_raise, softirq_entry and softirq_exit.
>>>>
>>>> And when this tracepoint is used in combination with
>>>> the softirq_entry tracepoint we can determine
>>>> the softirq raise latency.
>>>>
> 
>>> In file included from /home/mingo/tip/arch/sparc/include/asm/irq_32.h:11,
>>>                  from /home/mingo/tip/arch/sparc/include/asm/irq.h:6,
>>>                  from /home/mingo/tip/include/linux/irqnr.h:10,
>>>                  from /home/mingo/tip/include/linux/irq.h:22,
>>>                  from /home/mingo/tip/include/asm-generic/hardirq.h:6,
>>>                  from /home/mingo/tip/arch/sparc/include/asm/hardirq_32.h:11,
>>>                  from /home/mingo/tip/arch/sparc/include/asm/hardirq.h:6,
>>>                  from /home/mingo/tip/include/linux/hardirq.h:10,
>>>                  from /home/mingo/tip/include/linux/ftrace_event.h:7,
>>>                  from /home/mingo/tip/include/trace/syscall.h:6,
>>>                  from /home/mingo/tip/include/linux/syscalls.h:76,
>>>                  from /home/mingo/tip/init/initramfs.c:9:
>>> /home/mingo/tip/include/linux/interrupt.h: In function '__raise_softirq_irqoff':
>>> /home/mingo/tip/include/linux/interrupt.h:414: error: implicit declaration of function 'local_softirq_pending'
>>> /home/mingo/tip/include/linux/interrupt.h:414: error: lvalue required as left operand of assignment
>>> make[2]: *** [init/initramfs.o] Error 1
>>> make[2]: *** Waiting for unfinished jobs....
>>> In file included from /home/mingo/tip/arch/sparc/include/asm/irq_32.h:11,
>>
>> I could build sparc64_defconfig, but s390 is broken for me by this...
> 
> /me being very grumpy @ Lai.. ia64 is broken too!
> 
> /me goes revert this shite
> 

Now it is fixed.

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=9f081ce5da2c8af297a0a7d15a57fb4beeed374b;hp=43e3bf203456c4f06bdd6060426976ad2bed9081

