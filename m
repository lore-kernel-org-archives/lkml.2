Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0EWPHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 11:07:53 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:51160 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0EWPHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 11:07:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uZmeSePFtxHe2QayWUI9fRzZ82t9dqdCXOVpFpfqAnBigxX1U5Z923LamB8lKD5HB+
         ePVWoS5tJhTPc6UFYqdlCRp2tCRbpHFFiQlKeDaCIVe6YobIs/ZOulrIGdYPt55sLeoP
         pDI9kSRfVkGRc8R0Qjn3VC8TrRRVZp56+zxUg=
MIME-Version: 1.0
In-Reply-To: <20100523141300.GD950@n2100.arm.linux.org.uk>
References: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com>
	 <20100523123801.GC950@n2100.arm.linux.org.uk>
	 <AANLkTikRp0EHxshKYq39p18ymoRNAtyHrNm3yq6A49-r@mail.gmail.com>
	 <20100523141300.GD950@n2100.arm.linux.org.uk>
Date: Sun, 23 May 2010 23:07:50 +0800
Message-ID: <AANLkTinV9Na9zxYMIfTr893Ynnc0YOk2B6uPKEa9s4R1@mail.gmail.com>
Subject: Re: [RESEND PATCH] ARM: fix 'unannotated irqs-on' lockdep warning
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/23 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Sun, May 23, 2010 at 09:44:20PM +0800, Ming Lei wrote:
>> 2010/5/23 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>> >>  ENTRY(ret_to_user)
>> >>  ret_slow_syscall:
>> >> -     disable_irq                             @ disable interrupts
>> >> +     disable_irq_notrace                             @ disable interrupts
>> >
>> > I think this one does need to be traced - the pending work functions are
>> > all C code which could call back into lockdep.
>>
>> If there are pending works, schedule will be called to give cpu to it,
>> I wonder why the work function to be scheduled will be run with irq
>> disabled. Seems we should enable irq again before calling schedule,
>> not sure.
>
> No.  I'm talking about things like do_notify_resume().
>
> I think the above should be left as-is, so that as far as lockdep is
> concerned, IRQs are off while userspace runs.  What happens between
> returning to userspace and re-entering the kernel has no bearing what
> so ever on lockdep.
>

Oh, trace_ret_hardirqs_on has to be added before returning to user-space to
remove the warning, like x86 and mips. If you agree, I'd like to post
a new version
patch.

Thanks,

-- 
Lei Ming
