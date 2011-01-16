Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1APLvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 06:51:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41367 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1APLvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 06:51:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dhIhW/RUPa8LoLYp8fUSf+fAvjPhifYP9UpQKEwFyuKrrc3DDFhuwF4aF+lGB0CvH/
         nMUswS2btdAISVVjUdfCe61WU0TfiOOGpIixN2QJGhNRTW84gGtL2TgFAfOGGhob5TTy
         OPCkU9P/GG6iO8lna5MxVbHU3zAo6pNHbAhKU=
MIME-Version: 1.0
In-Reply-To: <20110115154319.GG15996@n2100.arm.linux.org.uk>
References: <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com>
	<20110114120229.GA15996@n2100.arm.linux.org.uk>
	<1295014231.7901.41.camel@e102109-lin.cambridge.arm.com>
	<20110114154919.GE15996@n2100.arm.linux.org.uk>
	<1295022193.7901.56.camel@e102109-lin.cambridge.arm.com>
	<20110114163520.GH15996@n2100.arm.linux.org.uk>
	<1295024327.7901.70.camel@e102109-lin.cambridge.arm.com>
	<20110114173050.GJ15996@n2100.arm.linux.org.uk>
	<20110114184759.GN15996@n2100.arm.linux.org.uk>
	<AANLkTi=p+f7TO+_g677VXNJkt-mu+8d8c6T9qgt5MVtn@mail.gmail.com>
	<20110115154319.GG15996@n2100.arm.linux.org.uk>
Date: Sun, 16 Jan 2011 11:51:47 +0000
X-Google-Sender-Auth: wJyuR_Ypwad-PISZA31Iha99rdo
Message-ID: <AANLkTinzWQyW=A0Z9sPnCYfEdKLNR8wY_+Yzw_8DPTfB@mail.gmail.com>
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 15 January 2011, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Jan 15, 2011 at 03:38:16PM +0000, Catalin Marinas wrote:
>> On 14 January 2011 18:47, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > diff -u b/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
>> > --- b/arch/arm/kernel/entry-armv.S
>> > +++ b/arch/arm/kernel/entry-armv.S
>> > @@ -499,10 +499,11 @@
>> >        blo     __und_usr_unknown
>> >  3:     ldrht   r0, [r4]
>> >        add     r2, r2, #2                      @ r2 is PC + 2, make it PC + 4
>> > -       orr     r0, r0, r5, lsl #16
>> > +       str     r2, [sp, #S_PC]                 @ it's a 2x16bit instr, update
>> > +       orr     r0, r0, r5, lsl #16             @  regs->ARM_pc
>> >        @
>> >        @ r0 = the two 16-bit Thumb instructions which caused the exception
>> > -       @ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc+2)
>> > +       @ r2 = PC value for the following Thumb instruction (:= regs->ARM_pc)
>> >        @ r4 = PC value for the first 16-bit Thumb instruction
>> >        @
>> >  #else
>>
>> Do we need to modify the VFP entry code to avoit the store to ARM_pc?
>
> The one after the sub #4 instruction?

No, I misread the code, we still need the one after sub #4.


-- 
Catalin
