Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032293Ab2CPG4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:56:37 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:33778 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030475Ab2CPG4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:56:35 -0400
Message-ID: <4F62E417.40905@numascale.com>
Date: Fri, 16 Mar 2012 07:56:23 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid()
 function.
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com> <1331834583-16070-1-git-send-email-sp@numascale.com> <CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com> <1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com> <CAE9FiQXXy3UDFpm5uCmpnn7Q53FhQN6h-BSAizgk_Sqkg+d4bA@mail.gmail.com> <CAE9FiQUtf9Pix3rmhgk_+oOf19dOvvgQYt+gbHQyag0xkH_bxA@mail.gmail.com>
In-Reply-To: <CAE9FiQUtf9Pix3rmhgk_+oOf19dOvvgQYt+gbHQyag0xkH_bxA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/2012 05:19, Yinghai Lu wrote:
> On Thu, Mar 15, 2012 at 7:08 PM, Yinghai Lu<yinghai@kernel.org>  wrote:
>>> So this change breaks the commit
>>> c284b42abadbb22083bfde24d308899c08d44ffa.
>>>
>>> I think the right thing is to have two different apid_id_valid checks
>>> one for xapic driver (apic_flat_64.c) and another for x2apic driver
>>> (x2apic_phys/cluster.c) and that way, x2apic MADT entries will be parsed
>>> only if bios has handed over the OS in x2apic mode or if we have
>>> selected the numachip model.
>>
>> that looks like more clear.
>
> after more thinking, I think We should still use cpu_has_x2apic checking.
>
> one maybe invalid case:
>
> System have some cpus apic id<  255, and some cpu apic id>  255.
> BSP apic id<  255.
> those cpus apic id<  255 will be put into xapic mode, cpus>  255 will
> be put into x2apic mode.
> and DMAR table intr-remapping will be working.

Hmm, I didn't know you could have two apic drivers (e.g. apic_flat_64 
and x2apic_*) available at the same time ? Or did I read the above wrong ?

>
> So if we check x2apic_mode early, will skip cpu with apic id>  255,
> even switch to x2apic later.
>

Which one of the two patches I sent, do you (Suresh/Yinghai/others) 
believe is the best/cleanest and works in all cases. I, unfortunately, 
can't test the Intel case as I don't have any available to test on :/

Either patch works fine for NumaChip enabled systems.

If desired I will re-post the patch with the approach you find best, but 
add the apic->apic_id_valid() check in the SRAT code aswell.

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
