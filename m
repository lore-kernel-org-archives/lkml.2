Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0HaH3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:29:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61648 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab0HaH3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=X33AptRye7xyy8kqPMIDzw/SWQYe3TDauE7kHUAStUmqENPtlh+zwYoZhvKsZKTNgE
         ZO6wLzUxHFNOZoYTwXOd8ZOXI7XpHKlNxe9s8lr1UWIfChhNoUgv+GTEUhWmZ4zbMs48
         HoKy7yq8LQHgLjdZUXhYv/YD2e+PhoB879T1o=
MIME-Version: 1.0
In-Reply-To: <AANLkTinN4w=P7oferD35bBMkPE+9z+2OyYsBcy3ptBzL@mail.gmail.com>
References: <1282813649-8332-1-git-send-email-mark.brown314@gmail.com>
 <1282813649-8332-2-git-send-email-mark.brown314@gmail.com>
 <AANLkTi=GZ1p3MzibOEzhyD=Mv6d2x2nRh93D4bmtgcYE@mail.gmail.com>
 <AANLkTimwU17YS5Yk7y+13Dj9Ww4oPG0g4v5ZbvOVuQV6@mail.gmail.com>
 <AANLkTikxOQnj=vKD8b0aZqZHNe4m-Y+o+620TBzMJCAW@mail.gmail.com>
 <AANLkTik3cnE4HQ3hq3wfuxcept4BeTh+zZvNDbZ_b3O7@mail.gmail.com>
 <AANLkTinjyJvMRt8OovZBJD+-xU6KXH5WAfqz9Epok+=g@mail.gmail.com>
 <AANLkTikrp0i_U_eKaAbUOop6U4Un6-ASTKuXU1HOzoc7@mail.gmail.com>
 <AANLkTinq8wFGmYKzBrEY1d3FadN+55urxLxQCFTcpcrM@mail.gmail.com>
 <AANLkTimAkhcSuBotE2eN=ETkFBmgMS6L=97wo+-woLHN@mail.gmail.com>
 <AANLkTi=NGyKtVPH2UgbR_Y2rBcFX7hzDAFkZw5KKetKT@mail.gmail.com> <AANLkTinN4w=P7oferD35bBMkPE+9z+2OyYsBcy3ptBzL@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 31 Aug 2010 15:28:54 +0800
Message-ID: <AANLkTik-AHuFLk8-B0vnE0m3Rjvumu_H9f-5Wu6a4g29@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: pxa168: fix corrected reset vector
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 3:28 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> On Tue, Aug 31, 2010 at 3:21 AM, Haojian Zhuang
> <haojian.zhuang@gmail.com> wrote:
>> On Tue, Aug 31, 2010 at 3:08 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
>>> On Tue, Aug 31, 2010 at 3:02 PM, Haojian Zhuang
>>> <haojian.zhuang@gmail.com> wrote:
>>>> On Tue, Aug 31, 2010 at 2:48 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
>>>>> On Tue, Aug 31, 2010 at 2:26 AM, Haojian Zhuang
>>>>> <haojian.zhuang@gmail.com> wrote:
>>>>>> On Tue, Aug 31, 2010 at 2:08 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
>>>>>>> On Tue, Aug 31, 2010 at 2:04 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
>>>>>>>> On Tue, Aug 31, 2010 at 2:02 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
>>>>>>>>> On Tue, Aug 31, 2010 at 1:48 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
>>>>>>>>>> On Thu, Aug 26, 2010 at 5:07 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
>>>>>>>>>>> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
>>>>>>>>>>> ---
>>>>>>>>>>>  arch/arm/mach-mmp/include/mach/system.h |    2 +-
>>>>>>>>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/arch/arm/mach-mmp/include/mach/system.h b/arch/arm/mach-mmp/include/mach/system.h
>>>>>>>>>>> index 4f5b0e0..926e9c0 100644
>>>>>>>>>>> --- a/arch/arm/mach-mmp/include/mach/system.h
>>>>>>>>>>> +++ b/arch/arm/mach-mmp/include/mach/system.h
>>>>>>>>>>> @@ -16,6 +16,6 @@ static inline void arch_idle(void)
>>>>>>>>>>>
>>>>>>>>>>>  static inline void arch_reset(char mode, const char *cmd)
>>>>>>>>>>>  {
>>>>>>>>>>> -       cpu_reset(0);
>>>>>>>>>>> +       cpu_reset(0xffff0000);
>>>>>>>>>>
>>>>>>>>>> Not sure if this correct. But normally reset jump happens after we turn
>>>>>>>>>> off the MMU and so on. Ain't the BootROM starts from 0 ?
>>>>>>>>>>
>>>>>>>>>>>  }
>>>>>>>>>>>  #endif /* __ASM_MACH_SYSTEM_H */
>>>>>>>>>>> --
>>>>>>>>>>> 1.7.0.4
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Eric, the boot-rom for pxa168 starts at 0xffff_0000. I am pretty sure
>>>>>>>>> about that! If you set the reset vector to 0x0 it will crash during
>>>>>>>>> reboot. I will send you xdb snapshots if you need me to.
>>>>>>>>>
>>>>>>>>
>>>>>>>> OK, you are expert on this :-)
>>>>>>>>
>>>>>>>> Applied to 'fix'.
>>>>>>>>
>>>>>>>
>>>>>>> One moment. Since this is really global to pxa910 and mmp2, so I
>>>>>>> suggest this being fixed for pxa168 only first. How about this:
>>>>>>>
>>>>>>>    ARM: pxa168: fix corrected reset vector
>>>>>>>
>>>>>>>    Reset vector for pxa168 is 0xffff_0000 not 0x0. This fix allows
>>>>>>>    reboot to work
>>>>>>>
>>>>>>>    Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
>>>>>>>
>>>>>>> diff --git a/arch/arm/mach-mmp/include/mach/system.h
>>>>>>> b/arch/arm/mach-mmp/include/mach/system.h
>>>>>>> index 4f5b0e0..1a8a25e 100644
>>>>>>> --- a/arch/arm/mach-mmp/include/mach/system.h
>>>>>>> +++ b/arch/arm/mach-mmp/include/mach/system.h
>>>>>>> @@ -9,6 +9,8 @@
>>>>>>>  #ifndef __ASM_MACH_SYSTEM_H
>>>>>>>  #define __ASM_MACH_SYSTEM_H
>>>>>>>
>>>>>>> +#include <mach/cputype.h>
>>>>>>> +
>>>>>>>  static inline void arch_idle(void)
>>>>>>>  {
>>>>>>>        cpu_do_idle();
>>>>>>> @@ -16,6 +18,9 @@ static inline void arch_idle(void)
>>>>>>>
>>>>>>>  static inline void arch_reset(char mode, const char *cmd)
>>>>>>>  {
>>>>>>> -       cpu_reset(0);
>>>>>>> +       if (cpu_is_pxa168())
>>>>>>> +               cpu_reset(0xffff0000);
>>>>>>> +       else
>>>>>>> +               cpu_reset(0);
>>>>>>>  }
>>>>>>>  #endif /* __ASM_MACH_SYSTEM_H */
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>>>
>>>>>> The reset code is in below.
>>>>>>
>>>>>>        .align  5
>>>>>> ENTRY(cpu_mohawk_reset)
>>>>>>        mov     ip, #0
>>>>>>        mcr     p15, 0, ip, c7, c7, 0           @ invalidate I,D caches
>>>>>>        mcr     p15, 0, ip, c7, c10, 4          @ drain WB
>>>>>>        mcr     p15, 0, ip, c8, c7, 0           @ invalidate I & D TLBs
>>>>>>        mrc     p15, 0, ip, c1, c0, 0           @ ctrl register
>>>>>>        bic     ip, ip, #0x0007                 @ .............cam
>>>>>>        bic     ip, ip, #0x1100                 @ ...i...s........
>>>>>>        mcr     p15, 0, ip, c1, c0, 0           @ ctrl register
>>>>>>        mov     pc, r0
>>>>>>
>>>>>> MMU is disabled at here and replace PC with r0 value. I doubt code
>>>>>> executed correctly at here. While MMU is disabled, the PC should be
>>>>>> continue in the range of 0xCxxx_xxxx (kernel space). "mov pc, r0"
>>>>>> shouldn't be executed. Instruction fetch failure should occurs since
>>>>>> there's no physical address in 0xCxxx_xxxx.
>>>>>>
>>>>>> Correct me if I'm wrong.
>>>>>>
>>>>>> Thanks
>>>>>> Haojian
>>>>>>
>>>>>
>>>>> Haojian,
>>>>>
>>>>> I think there is a pipeline execution of the mov pc, r0 instruction.
>>>>> If I remember correctly you need to do a similar jump when you turn
>>>>> the MMU on in early boot code. If it makes any difference I did test
>>>>> this code on pxa168 before submitting it. I will double check the mmp2
>>>>> and the pxa910 reset vectors with the Boot ROM developers.
>>>>>
>>>>
>>>> In early boot code, 1:1 (physical:virtual) mapping is used. It means
>>>> that physical address is same as virtual address. So you can operature
>>>> mmu as you wish.
>>>>
>>>> By the way, I don't suggest to reset CPU by this way. Reset is not
>>>> only make code running from the head, it should also clear registers
>>>> and RTL logic in CPU.
>>>>
>>>
>>> Depends on if pxa168 has a reset signal asserted from internal or from
>>> external GPIO, which is controllable from the CPU itself. That's what
>>> pxa is doing at this moment.
>>>
>>
>> Yes, it depends on reset signal. Watchdog timer is built in pxa168. So
>> I think that watchdog reset could be better.
>>
>
> Haojian,
>
> That is true, I am planning to send an update to support watchdog
> timer reset soon. The problem is I need to test pxa910 and mmp2 as
> well and determine if the watchdog reset code is consistent. It was
> simpler for me to just fix this at the moment.
>

This fix can go ahead in my POV.
