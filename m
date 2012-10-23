Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2JWMeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:34:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60324 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2JWMeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:34:22 -0400
MIME-Version: 1.0
In-Reply-To: <1350902505.2768.88.camel@twins>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
	<1350750167-14263-6-git-send-email-fweisbec@gmail.com>
	<1350902505.2768.88.camel@twins>
Date: Tue, 23 Oct 2012 14:34:21 +0200
Message-ID: <CAFTL4hxDM7fyKRMCMBwqmCo4KVAyp1Ciyz+tm=awtJ5PoqJQMA@mail.gmail.com>
Subject: Re: [RFC PATCH 5/8] irq_work: Make self-IPIs optable
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/22 Peter Zijlstra <peterz@infradead.org>:
> On Sat, 2012-10-20 at 12:22 -0400, Frederic Weisbecker wrote:
>> +       if (empty) {
>> +               /*
>> +                * If an IPI is requested, raise it right away. Otherwise wait
>> +                * for the next tick unless it's stopped. Now if the arch uses
>> +                * some other obscure way than IPI to raise an irq work, just raise
>> +                * and don't think further.
>> +                */
>> +               if (ipi || !arch_irq_work_has_ipi() || tick_nohz_tick_stopped())
>> +                       arch_irq_work_raise();
>> +       }
>>         preempt_enable();
>>  }
>
> Doesn't this have a problem where we enqueue the first lazy and then one
> with ipi? In that case it appears we won't send the IPI because the
> queue wasn't empty.

Good point! I need to send an ipi in that case. Will fix on the next version.

Thanks.
