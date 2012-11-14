Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab2KNTlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:41:22 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:40979 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2KNTlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:41:21 -0500
MIME-Version: 1.0
In-Reply-To: <1352921090.18025.73.camel@gandalf.local.home>
References: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
	<1352910413-10759-5-git-send-email-fweisbec@gmail.com>
	<1352921090.18025.73.camel@gandalf.local.home>
Date: Wed, 14 Nov 2012 20:41:19 +0100
Message-ID: <CAFTL4hwmPdaGnRXF3eAK=2id8hgQyLTqjttV=V1uF+nQU5isSw@mail.gmail.com>
Subject: Re: [PATCH 4/4] vtime: No need to disable irqs on vtime_account()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/14 Steven Rostedt <rostedt@goodmis.org>:
> On Wed, 2012-11-14 at 17:26 +0100, Frederic Weisbecker wrote:
>> vtime_account() is only called from irq entry. irqs
>> are always disabled at this point so we can safely
>> remove the irq disabling guards on that function.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: Fenghua Yu <fenghua.yu@intel.com>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> ---
>>  kernel/sched/cputime.c |    6 ------
>>  1 files changed, 0 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
>> index 2e8d34a..80b2fd5 100644
>> --- a/kernel/sched/cputime.c
>> +++ b/kernel/sched/cputime.c
>> @@ -467,16 +467,10 @@ void vtime_task_switch(struct task_struct *prev)
>>  #ifndef __ARCH_HAS_VTIME_ACCOUNT
>>  void vtime_account(struct task_struct *tsk)
>>  {
>> -     unsigned long flags;
>> -
>> -     local_irq_save(flags);
>> -
>
> I'd add a WARN_ON_ONCE(!irqs_disabled()) again here, or is this also
> covered by the vtime_delta()?

Yeah it's the ending point for both vtime_account_system() and
vtime_account_idle()
