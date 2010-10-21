Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0JURKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:10:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab0JURKf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:10:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qe4nXj58LqVhBuqy8XEUIOsTBCgcEDlk8b68sqkjGf0eBlg1htNNBgEkVOUivmDkX3
         4MPkffd1P1gj6BdD9qUw==
MIME-Version: 1.0
In-Reply-To: <1287673121.6871.108.camel@edumazet-laptop>
References: <1287614941-32325-1-git-send-email-venki@google.com>
	<1287614941-32325-2-git-send-email-venki@google.com>
	<1287638608.2545.98.camel@edumazet-laptop>
	<AANLkTi=QyTJ0vZ=U3Ts7bB-DGvtTuQ_M6k8igkKiv6EE@mail.gmail.com>
	<1287673121.6871.108.camel@edumazet-laptop>
Date: Thu, 21 Oct 2010 10:03:43 -0700
Message-ID: <AANLkTimRz9SNyyzZXugVOtp9f7fbyHEkOgeWoDF3Hh2R@mail.gmail.com>
Subject: Re: [PATCH 1/6] Free up pf flag PF_KSOFTIRQD
From: Venkatesh Pallipadi <venki@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 7:58 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 21 octobre 2010 à 07:36 -0700, Venkatesh Pallipadi a écrit :
>
>> Yes. I thought about static inline part. The reason I did not make
>> this static inline was because ksoftirqd was declared static in
>> softirq.c and this function was getting called from sched.c.
>>
>
> I believe you can remove the 'static' for this kind of thing.
>
>> I did not know that this_cpu_read existed though. I guess I should be
>> looking at using that elsewhere in the patchset too.
>>
>
> Sure :)
>
>> Also, part of the overhead you see below I think is coming from
>> DEBUG_PREEMPT. That would be making every smp_processor_id() call more
>> expensive. No?
>>
>
> Right, but the point is the this_cpu_read() version doesnt have this
> overhead, even if DEBUG_PREEMPT is on, at least on x86.
>

Agreed. Will redo this when I refresh the patchset.

Thanks,
Venki

> BTW, I lied somehow, because the way this_cpu_read() is handled,
> following code :
>
>        p == this_cpu_read(ksoftirqd);
>
> generates :
>
> mov     %gs:offset,%rax
> cmp     %rdi,%rax
>
> not :
>
> cmp     %gs:offset,%rdi
>
>
>
>
