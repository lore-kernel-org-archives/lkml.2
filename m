Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab1CaPhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:37:52 -0400
Received: from relay2.sgi.com ([192.48.179.30]:51298 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758200Ab1CaPhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:37:50 -0400
Message-ID: <4D949FCA.70503@sgi.com>
Date: Thu, 31 Mar 2011 08:37:46 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] printk: Allocate kernel log buffer earlier v2
References: <20110225180634.017570095@gulag1.americas.sgi.com> <20110227120949.GF16453@elte.hu> <20110227121518.GA19165@elte.hu> <4D6AFBB0.70401@kernel.org> <4D6BF63D.2020404@sgi.com> <AANLkTi=Sn6DKAjGHQjtWGiLGh8vpuS-vmXK=TMDrbjdv@mail.gmail.com> <4D6BFF46.3050001@sgi.com> <AANLkTi=Xf5RaF559QsRNijmG0YP7amkG569NZFhpt4QY@mail.gmail.com> <4D93CDD7.8000708@sgi.com> <4D93D180.6020300@sgi.com> <20110331064820.GB5938@elte.hu>
In-Reply-To: <20110331064820.GB5938@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Subject: printk: Allocate kernel log buffer earlier v2
>>
>> On larger systems, because of the numerous ACPI, Bootmem and EFI
>> messages, the static log buffer overflows before the larger one
>> specified by the log_buf_len param is allocated.  Minimize the
>> overflow by allocating the new log buffer as soon as possible.
>>
>> The allocation method is passed in as an argument to make
>> backporting to "pre-memblock" kernels easier.
> 
> Hm, all that allocation pointer magic looks a tad too complex and non-obvious.
> 
> Why not just make it as simple and obvious as possible for the current kernel - 
> and we can still mark it -stable and you backport it to the non-memblock 
> kernel? That keeps compatibility complexity out of upstream ...
> 
> Thanks,
> 
> 	Ingo

Sure, I can do that.

THanks,
Mike
