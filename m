Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2HCS2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:28:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:34605 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2HCS2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:28:37 -0400
Message-ID: <501C183E.5000303@linutronix.de>
Date: Fri, 03 Aug 2012 20:28:14 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: fix set_task_blockstep()->update_debugctlmsr()
 logic
References: <20120803162954.GA19806@redhat.com> <501BFF95.8040202@linutronix.de> <20120803173830.GA22687@redhat.com>
In-Reply-To: <20120803173830.GA22687@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 07:38 PM, Oleg Nesterov wrote:
>>>    	update_debugctlmsr(debugctl);
>>> +	local_irq_enable();
>>
>> wouldn't preempt_disable() be enough?
>
> preempt_disable() can't help if interrupt handler changes
> other bits in between?

So perf() uses this register as well. Since perf() uses the raw
primitives (raw_spin_lock()) shouldn't you do the same? If I recall
correctly (but it is Friday and late) local_irq_enable() wouldn't
disable irqs on RT and perf takes the raw lock so the irqs there should
be really disabled.

>
> Oleg.

Sebastian
