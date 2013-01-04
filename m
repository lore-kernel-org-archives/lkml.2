Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3ADNmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:42:15 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:34911 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3ADNmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:42:12 -0500
MIME-Version: 1.0
In-Reply-To: <1356933285.16700.4.camel@ThinkPad-T5421.cn.ibm.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
	<1356799386-4212-6-git-send-email-fweisbec@gmail.com>
	<1356933285.16700.4.camel@ThinkPad-T5421.cn.ibm.com>
Date: Fri, 4 Jan 2013 14:42:11 +0100
Message-ID: <CAFTL4hyB500N+W9R0DZQ_QfyHULfnceKqgNHwkEHtxqiBa87ww@mail.gmail.com>
Subject: Re: [PATCH 05/27] cputime: Safely read cputime of full dynticks CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/31 Li Zhong <zhong@linux.vnet.ibm.com>:
> On Sat, 2012-12-29 at 17:42 +0100, Frederic Weisbecker wrote:
>>  static inline void vtime_task_switch(struct task_struct *prev) { }
>>  static inline void vtime_account_system(struct task_struct *tsk) { }
>>  static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
>>  static inline void vtime_account_user(struct task_struct *tsk) { }
>> -static inline void vtime_account(struct task_struct *tsk) { }
>> +static inline void vtime_account_irq_enter(struct task_struct *tsk) { }
>>  static inline bool vtime_accounting(void) { return false; }
>>  #endif
>>
>>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
>> -static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
>> +extern void arch_vtime_task_switch(struct task_struct *tsk);
>> +extern void vtime_account_irq_exit(struct task_struct *tsk);
>> +extern void vtime_user_enter(struct task_struct *tsk);
>> +extern bool vtime_accounting(void);
>> +#else
>> +static inline void vtime_account_irq_exit(struct task_struct *tsk)
>> +{
>> +     /* On hard|softirq exit we always account to hard|softirq cputime */
>> +     vtime_account_system(tsk);
>> +}
>> +static inline void vtime_enter_user(struct task_struct *tsk) { }
>
> I guess the function name above should be "vtime_user_enter" to match
> the above extern, and the usage in user_enter()?

Totally! Thanks for pointing this out.
