Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768226Ab2KOPiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:38:51 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52622 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab2KOPit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:38:49 -0500
MIME-Version: 1.0
In-Reply-To: <1352951981.18025.90.camel@gandalf.local.home>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	<1352925457-15700-6-git-send-email-fweisbec@gmail.com>
	<1352951981.18025.90.camel@gandalf.local.home>
Date: Thu, 15 Nov 2012 16:38:47 +0100
Message-ID: <CAFTL4hwrTFE3oogM=9ejTVLM5aetSoJyJQoS0wS6Qj4MktBwfQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] irq_work: Don't stop the tick with pending works
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/15 Steven Rostedt <rostedt@goodmis.org>:
> On Wed, 2012-11-14 at 21:37 +0100, Frederic Weisbecker wrote:
>> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
>> index 64eddd5..b3c113a 100644
>> --- a/kernel/irq_work.c
>> +++ b/kernel/irq_work.c
>> @@ -99,6 +99,17 @@ bool irq_work_queue(struct irq_work *work)
>>  }
>>  EXPORT_SYMBOL_GPL(irq_work_queue);
>>
>> +bool irq_work_needs_cpu(void)
>> +{
>> +     struct llist_head *this_list;
>> +
>> +     this_list = &__get_cpu_var(irq_work_list);
>> +     if (llist_empty(this_list))
>> +             return false;
>> +
>
> I wounder if this should just be:
>
>         return !llist_empty(&this_cpu_read(irq_work_list));

Yeah I'll simplify that way.
