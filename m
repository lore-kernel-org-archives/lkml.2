Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0JURGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:06:42 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0JURGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vyHDNiaiXxjZZsT98W8KCyDlt8xJDY3d4pf9E6TXgPIxouYqfOiClx7rVpnUq1oN3k
         qgfgaJfwp87sg+O+A/Yg==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1010211012220.24115@router.home>
References: <1287614941-32325-1-git-send-email-venki@google.com>
	<1287614941-32325-2-git-send-email-venki@google.com>
	<alpine.DEB.2.00.1010211012220.24115@router.home>
Date: Thu, 21 Oct 2010 10:06:36 -0700
Message-ID: <AANLkTi=gkGmCsTYGjtxrUUXFaP3NCtj0YdGLh+QNnjR9@mail.gmail.com>
Subject: Re: [PATCH 1/6] Free up pf flag PF_KSOFTIRQD
From: Venkatesh Pallipadi <venki@google.com>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 8:13 AM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 20 Oct 2010, Venkatesh Pallipadi wrote:
>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index abf8440..5d4afe9 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -1984,9 +1984,9 @@ void account_system_vtime(struct task_struct *curr)
>>        * in that case, so as not to confuse scheduler with a special task
>>        * that do not consume any time, but still wants to run.
>>        */
>> -     if (hardirq_count())
>> +     if (in_irq())
>>               per_cpu(cpu_hardirq_time, cpu) += delta;
>
> If cpu is always the current cpu then you can optimize the code:
>
>        this_cpu_add(cpu_hardirq_time, delta)
>
>> -     else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
>> +     else if (in_serving_softirq() && !(is_ksoftirqd_context()))
>>               per_cpu(cpu_softirq_time, cpu) += delta;
>
> Same here.
>

Yes. this_cpu_* variants were my learning of the day for today :-).
Will cleanup various per_cpu() and __get_cpu_var() when I refresh this
patchset.

Thanks,
Venki
