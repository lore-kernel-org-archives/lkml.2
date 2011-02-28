Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab1B1UCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:02:14 -0500
Received: from relay2.sgi.com ([192.48.179.30]:34557 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754535Ab1B1UCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:02:13 -0500
Message-ID: <4D6BFF46.3050001@sgi.com>
Date: Mon, 28 Feb 2011 12:02:14 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
References: <20110225180633.857892225@gulag1.americas.sgi.com>	<20110225180634.017570095@gulag1.americas.sgi.com>	<20110227120949.GF16453@elte.hu>	<20110227121518.GA19165@elte.hu>	<4D6AFBB0.70401@kernel.org>	<4D6BF63D.2020404@sgi.com> <AANLkTi=Sn6DKAjGHQjtWGiLGh8vpuS-vmXK=TMDrbjdv@mail.gmail.com>
In-Reply-To: <AANLkTi=Sn6DKAjGHQjtWGiLGh8vpuS-vmXK=TMDrbjdv@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
> On Mon, Feb 28, 2011 at 11:23 AM, Mike Travis <travis@sgi.com> wrote:
>>
>> Yinghai Lu wrote:
>>> On 02/27/2011 04:15 AM, Ingo Molnar wrote:
>>>> * Ingo Molnar <mingo@elte.hu> wrote:
>>>>
>>>>> You could avoid all this ugly workaround of bootmem limitations by
>>>>> moving the allocation to memblock_alloc() and desupporting the log_buf_len=
>>>>> boot parameter on non-memblock architectures.
>>>> memblock_alloc() could return -ENOSYS on architectures that do not
>>>> implement it - thus enabling such optional features without ugly #ifdef
>>>> CONFIG_HAVE_MEMBLOCK conditionals.
>>> Mike,
>>>
>>> please check updated patch...
>>>
>>> with the memblock change, you don't need to change acpi SRAT handling etc
>>> any more.
>> I had to debug a weird ACPI -> Node mapping last week and the
>> "improved" SRAT messages helped that considerably.  It was
>> far easier to spot which Node didn't have the correct assignments.
>> I'd submit that patch even without needing fewer (like 512 lines
>> max instead of 4096 lines max) bytes in the log buffer.
> 
> Your current change to ACPI srat is not complete yet.
> 
> you only handle x2apic entries.
> 
> According to ACPI 4.0 spec, We should have mixed entries with apic
> entries and x2apic entries.
> apic entries are for apic id < 255.
> x2apic entries are for apic id > 255.
> 
> Yinghai

Are you sure you can run both "legacy" and "x2" apic modes in
the same SSI under the Intel or AMD rules?

(And it's highly probable that you cannot overflow the log
buffer with less than 256 CPU's.)

Thanks,
Mike
