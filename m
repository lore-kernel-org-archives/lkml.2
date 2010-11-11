Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0KKJvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:51:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:59364 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab0KKJvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:51:37 -0500
Message-ID: <4CDBBCA5.50306@windriver.com>
Date: Thu, 11 Nov 2010 17:51:33 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at
 the same time on SMP
References: <1289442042-2515-1-git-send-email-dongdong.deng@windriver.com> <20101111092301.GD18789@elte.hu>
In-Reply-To: <20101111092301.GD18789@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2010 09:50:59.0608 (UTC) FILETIME=[F1B64980:01CB8185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dongdong Deng <dongdong.deng@windriver.com> wrote:
> 
>> +static int backtrace_flag;
> 
>> +	if (cmpxchg(&backtrace_flag, 0, 1) != 0)
> 
> Sorry to be a PITA, but i asked for test_and_set() because that's the simplest 
> primitive. cmpxchg() semantics is not nearly as obvious and people regularly get it 
> wrong :-/

As the 'backtrace_flag' could be accessed by multi-cpus on SMP at the 
same time, I use cmpxchg() for getting a atomic/memory barrier operation 
for 'backtrace_flag' variable.

If we use test_and_set, maybe we need smp_wmb() after test_and_set. (If 
I wrong, please correct me, thanks. :-) )

Should we still need to use test_and_set?
If need, I will use test_and_set at my next patch.

> 
> Also, variables that cmpxchg or test_and_set operates on need to be long, not int.

Got it, I will change it to 'unsigned long' type.

Thanks for your teaching.

Dongdong


> 
> 	Ingo
> 

