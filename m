Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1LTU1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:27:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:43745 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1LTU05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:26:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98485574"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>
Date: Wed, 21 Dec 2011 04:26:48 +0800
Subject: RE: [Regression, bisected]
 a3e06bbe8445f57eb949e6474c5a9b30f24d2057: KVM: emulate lapic tsc deadline
 timer for guest"
Thread-Topic: [Regression, bisected]
 a3e06bbe8445f57eb949e6474c5a9b30f24d2057: KVM: emulate lapic tsc deadline
 timer for guest"
Thread-Index: Acy/VSd3YcfdftlaT9y63HIa+DG9OQAAEICw
Message-ID: <BC00F5384FCFC9499AF06F92E8B78A9E2890487875@shsmsx502.ccr.corp.intel.com>
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com>
 <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com>
 <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E289048786F@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DGfhJBA6C6bzrnfVBxdyCM8a6J48dxb1DZfBwoFygtQvw@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E2890487874@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DFhLTFi7sVRehhNYSd7Nq_v-Wzd09BJ+JSiTVwbEpMTYw@mail.gmail.com>
In-Reply-To: <CAB9v_DFhLTFi7sVRehhNYSd7Nq_v-Wzd09BJ+JSiTVwbEpMTYw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Zaytsev wrote:
> On Tue, Dec 20, 2011 at 22:19, Liu, Jinsong <jinsong.liu@intel.com>
> wrote: 
>> Alexey Zaytsev wrote:
>>> On Tue, Dec 20, 2011 at 21:21, Liu, Jinsong <jinsong.liu@intel.com>
>>> wrote:
>>>> Linus Torvalds wrote:
>>>>> On Tue, Dec 20, 2011 at 1:51 AM, Alexey Zaytsev
>>>>> <alexey.zaytsev@gmail.com> wrote:
>>>>>> 
>>>>>> Let me clarify the situation.
>>>>>> 
>>>>>> Before this commit, the tsc was advertised in cpuid, and it was
>>>>>> handled, if I understand things correctly, by qemu.
>>>>>> After this commit, the tsc is advertised in cpuid, and is handled
>>>>>> in the kernel, but only after qemu issues KVM_CREATE_IRQCHIP. If
>>>>>> it does not issue the ioctl, the kernel just discards any wrmsrs
>>>>>> done to the tsc. This does not look like an Illumos problem to
>>>>>> me. Linux guests kind of work here, because they are  prepared
>>>>>> to work on utterly broken hardware. Good for you, but please
>>>>>> don't break less-prepared guests.
>>>>> 
>>>>> Yes. This is a regression, and needs to be fixed.
>>>>> 
>>>>> Liu, if you don't have time to debug it, we'll just revert the
>>>>> commit. It's that easy. Regressions are not allowed. There are no
>>>>> excuses. 
>>>>> 
>>>>> In particular, saying "just wait for qemu-kvm" is not an
>>>>> acceptable answer, because the point is that things *used* to
>>>>> work, and they broke. No "change it to work with the new kernel"
>>>>> allowed, except for some *very* rare critical circumstances
>>>>> (usually "major security-bug that we had to fix, and people who
>>>>> relied on it are thus out of luck"). 
>>>>> 
>>>>> Commit a3e06bbe8445 still seems to revert cleanly, so that is the
>>>>> easy option. 
>>>>> 
>>>>> That said, it sounds like maybe another solution is to start with
>>>>> the TSC_DEADLINE timer bit in cpuid cleared, and only setting it
>>>>> after the KVM_CREATE_IRQCHIP ioctl.
>>>>> 
>>>>> In fact, the patch is clearly buggy, in that it apparently doesn't
>>>>> emulate TSC_DEADLINE correctly and natively on its own.
>>>>> 
>>>>> Jan, Marcelo, Avi - is there a quick fix, or should I just revert?
>>>>> 
>>>>> And please don't *EVER* tell people that they should just work
>>>>> around regressions. Regressions are absolutely unacceptable.
>>>>> Kernel people need to understand that.
>>>>> 
>>>>>                    Linus
>>>> 
>>>> Yes, my fault to say 'walk around' before knowing Alex's issue
>>>> clearly. 
>>>> 
>>>> After Alex send his last email to clarify the situation, I have
>>>> checked the bug. Basically it caused from
>>>> 1. qemu didn't issue KVM_CREATE_IRQCHIP, hence
>>>> irqchip_in_kernel(kvm) fail when setup vcpu lapic logic at
>>>> kvm_arch_vcpu_init(); 
>>>> 2. tsc deadline work based on vcpu lapic, hence break illumos;
>>>> 
>>>> A fix is to update cpuid, as you said, setting it after
>>>> KVM_CREATE_IRQCHIP. I just wonder is there any better solution? so
>>>> I ask Alex his environment to setup at my side to do more test. If
>>>> you think kvm tsc deadline timer patch itself not clean, please
>>>> tell me. 
>>> 
>>> [Removed Linus from CC]
>>> 
>>> If your internet connection is good enough, I could just pass you
>>> the disk image. It should be around 5g when compressed. Otherwise,
>>> you can download an openindiana disk image from
>>> http://openindiana.org. You probably want the text-only "server"
>>> one. The TSC code has changed since that release, but the old one
>>> does not work as well. 
>> 
>> I mean I will build environment at my side with your qemu version
>> (where do you pull from? commit number?) --> just to verify whether
>> we can solve it at qemu side, or, solve it by cpuid at kvm side. I
>> will present a patch to fix it and you can test at your environment.
>> 
>>> 
>>> Do I get it right that Linux does not use the tsc deadline timer?
>>> I've added printks to the
>>> kvm_get_lapic_tscdeadline_msr/kvm_set_lapic_tscdeadline_msr
>>> functions, and I swear I've seen them trigger a few times with the
>>> Linux guest. But I can't find the code that is issuing the msr
>>> reads/writes in the Linux kernel. 
>> 
>> I will check it tomorrow, too late now.
>> and would you please tell me, does illumos use tsc deadline timer? I
>> lack this basic information. 
> 
> It does, if available. Please check
> https://github.com/illumos/illumos-gate/blob/master/usr/src/uts/i86pc/io/pcplusmp/apic_timer.c#L290
> 

and where do you pull qemu? and commit number? I usually use Avi's qemu-kvm.

Thanks,
Jinsong
