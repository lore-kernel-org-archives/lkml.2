Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0HBPUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:20:05 -0400
Received: from claw.goop.org ([74.207.240.146]:56852 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0HBPUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:20:03 -0400
Message-ID: <4C56E221.6050800@goop.org>
Date: Mon, 02 Aug 2010 08:20:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: vatsa@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        npiggin@suse.de, kvm@vger.kernel.org, bharata@in.ibm.com,
        Balbir Singh <balbir@in.ibm.com>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 3/4] Paravirtualized spinlock implementation for KVM
 guests
References: <20100726061150.GB21699@linux.vnet.ibm.com> <20100726061537.GC8402@linux.vnet.ibm.com> <4C568669.40001@redhat.com>
In-Reply-To: <4C568669.40001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/02/2010 01:48 AM, Avi Kivity wrote:
>  On 07/26/2010 09:15 AM, Srivatsa Vaddagiri wrote:
>> Paravirtual spinlock implementation for KVM guests, based heavily on 
>> Xen guest's
>> spinlock implementation.
>>
>>
>> +
>> +static struct spinlock_stats
>> +{
>> +    u64 taken;
>> +    u32 taken_slow;
>> +
>> +    u64 released;
>> +
>> +#define HISTO_BUCKETS    30
>> +    u32 histo_spin_total[HISTO_BUCKETS+1];
>> +    u32 histo_spin_spinning[HISTO_BUCKETS+1];
>> +    u32 histo_spin_blocked[HISTO_BUCKETS+1];
>> +
>> +    u64 time_total;
>> +    u64 time_spinning;
>> +    u64 time_blocked;
>> +} spinlock_stats;
>
> Could these be replaced by tracepoints when starting to spin/stopping 
> spinning etc?  Then userspace can reconstruct the histogram as well as 
> see which locks are involved and what call paths.

Unfortunately not; the tracing code uses spinlocks.

(TBH I haven't actually tried, but I did give the code an eyeball to 
this end.)

     J

