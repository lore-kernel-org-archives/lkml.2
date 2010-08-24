Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab0HXVtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:49:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61345 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab0HXVs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:48:58 -0400
Message-ID: <4C743E00.1040601@kernel.org>
Date: Tue, 24 Aug 2010 14:47:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Daniel Kiper <dkiper@net-space.pl>
CC: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Fix apic=debug boot crash
References: <20100819224616.GB9967@router-fw-old.local.net-space.pl> <tip-05e407603e527f9d808dd3866d3a17c2ce4dfcc5@git.kernel.org> <AANLkTim9kjBp68LqieU3MDLbkRDiWLNQjtUvjEbc9Hca@mail.gmail.com> <20100823081212.GA13297@router-fw-old.local.net-space.pl> <9cca0990-1b78-40e7-a71d-f550b4f504aa@email.android.com> <4C72B6F7.8010706@kernel.org> <20100824213931.GA1192@router-fw-old.local.net-space.pl>
In-Reply-To: <20100824213931.GA1192@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2010 02:39 PM, Daniel Kiper wrote:
> Hello,
> 
> On 08/23/2010 07:54 AM, H. Peter Anvin wrote:
>> It's already applied.
> 
> Thx.
> 
> On Mon, Aug 23, 2010 at 10:59:19AM -0700, Yinghai Lu wrote:
> [...]
>>>>>> x86, apic: Fix apic=debug boot crash
>>>>>>
>>>>>> Fix a boot crash when apic=debug is used and the APIC is
>>>>>> not properly initialized.
>>>>>>
>>>>>> This issue appears during Xen Dom0 kernel boot but the
>>>>>> fix is generic and the crash could occur on real hardware
>>>>>> as well.
>>>>>
>>>>> Do you have any report on real hardware?
>>>>> that could not happen on real hardware.
>>>>
>>>> Till now no, however I think it is good idea
>>>> to apply this patch now. It is not worth to wait
>>>> for another null pointer dereference.
>>
>> no, we should add BUG_ON() etc debug info there to see why that null cfg could happen.
>> because according to code, we should have null there.
> 
> I think that BUG_ON() is too strong here because
> it is "debug" function and it should work also
> with let's say "invalid" data (in Xen case it is
> normal because APIC state is managed directly
> by hypervisor).
> 
> Additionally, with this patch it is easy to
> differentiate between cfg != NULL and
> cfg == NULL. Please look below:
> 
> cfg != NULL:
> IRQ to pin mappings:
> IRQ0 -> 0:2
> IRQ1 -> 0:1
> IRQ3 -> 0:3
> IRQ4 -> 0:4
> IRQ5 -> 0:5
> IRQ6 -> 0:6
> IRQ7 -> 0:7
> IRQ8 -> 0:8
> IRQ9 -> 0:9
> IRQ10 -> 0:10
> IRQ11 -> 0:11
> IRQ12 -> 0:12
> IRQ13 -> 0:13
> IRQ14 -> 0:14
> IRQ15 -> 0:15
> .................................... done.
> 
> cfg == NULL:
> IRQ to pin mappings:
> .................................... done.
> 
> If I missed something or if you have any
> questions please drop me a line.

I mean you should figure out why xen ops could have null cfg.

Yinghai
