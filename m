Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab2BWUDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:03:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61063 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2BWUDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:03:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.50.222.132 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
In-Reply-To: <20120223075027.GB15306@elte.hu>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	<20120223075027.GB15306@elte.hu>
Date: Thu, 23 Feb 2012 12:03:48 -0800
Message-ID: <CABeCy1YnuD_O_aj_unpRGsokPtSpcRLRKRA-PF07rg8Rk-z_cg@mail.gmail.com>
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES interrupts
 to an idle CPU -v1
From: Venki Pallipadi <venki@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Resending without the ugly email client formatting ]

On Wed, Feb 22, 2012 at 11:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Venkatesh Pallipadi <venki@google.com> wrote:
>
>> * Do we need some accounting for these wakeups exported for powertop?
>
> If then tracepoints.
>
>> * We can also eliminate TS_POLLING flag in favor of this. But, that will have
>>   a lot more touchpoints and better done as a standlone change.
>
> Should most definitely be done for this series to be acceptble -
> as a preparatory patch in the series, with the feature at the
> end of the series.
>
OK. Will look at TS_POLLING part and likely include it in the next resend.

>> +DECLARE_PER_CPU(atomic_t *, idle_task_ti_flags);
>
> That's ugly, we should access the idle task's ti flags directly.
>
> To have efficient percpu access to the idle threads another
> clean-up is needed: we should turn idle_thread_array into a
> full-structure PER_CPU area.
>
> For that we need a small variant of fork_idle(), which does not
> dup the init thread - pretty trivial.
>
> fork_idle() should also make sure it does not schedule the child
> thread: thus we'd also be able to further simplify smpboot.c and
> get rid of all that extremely ugly 'struct create_idle'
> gymnastics in smpboot.c.
>

Hmm. Not being very familiar with that code, I will have to take a closer
look at this potential cleanup...

Thanks,
Venki

> Thanks,
>
>        Ingo
