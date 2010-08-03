Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0HCG7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 02:59:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab0HCG7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 02:59:36 -0400
Message-ID: <4C57BE44.9020001@redhat.com>
Date: Tue, 03 Aug 2010 09:59:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: vatsa@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        npiggin@suse.de, kvm@vger.kernel.org, bharata@in.ibm.com,
        Balbir Singh <balbir@in.ibm.com>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 3/4] Paravirtualized spinlock implementation for KVM
 guests
References: <20100726061150.GB21699@linux.vnet.ibm.com> <20100726061537.GC8402@linux.vnet.ibm.com> <4C568669.40001@redhat.com> <4C56E221.6050800@goop.org>
In-Reply-To: <4C56E221.6050800@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/02/2010 06:20 PM, Jeremy Fitzhardinge wrote:
>  On 08/02/2010 01:48 AM, Avi Kivity wrote:
>>  On 07/26/2010 09:15 AM, Srivatsa Vaddagiri wrote:
>>> Paravirtual spinlock implementation for KVM guests, based heavily on 
>>> Xen guest's
>>> spinlock implementation.
>>>
>>>
>>> +
>>> +static struct spinlock_stats
>>> +{
>>> +    u64 taken;
>>> +    u32 taken_slow;
>>> +
>>> +    u64 released;
>>> +
>>> +#define HISTO_BUCKETS    30
>>> +    u32 histo_spin_total[HISTO_BUCKETS+1];
>>> +    u32 histo_spin_spinning[HISTO_BUCKETS+1];
>>> +    u32 histo_spin_blocked[HISTO_BUCKETS+1];
>>> +
>>> +    u64 time_total;
>>> +    u64 time_spinning;
>>> +    u64 time_blocked;
>>> +} spinlock_stats;
>>
>> Could these be replaced by tracepoints when starting to spin/stopping 
>> spinning etc?  Then userspace can reconstruct the histogram as well 
>> as see which locks are involved and what call paths.
>
> Unfortunately not; the tracing code uses spinlocks.
>
> (TBH I haven't actually tried, but I did give the code an eyeball to 
> this end.)

Hm.  The tracing code already uses a specialized lock (arch_spinlock_t), 
perhaps we can make this lock avoid the tracing?

It's really sad, btw, there's all those nice lockless ring buffers and 
then a spinlock for ftrace_vbprintk(), instead of a per-cpu buffer.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

