Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0EWNoX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 09:44:23 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:54663 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab0EWNoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 09:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w7Pw2F8qEl9TSDA8Rguz2lHzQiiotzdMt0/D4XEUY6hnu76/QjBMaGGj/L048BoXfG
         xROOldYwX/KwSPo9ioITe8SzpEdVQ4PXaXbVXi2T0pGljsH0EVWPjlqr9TfeBKQT6Rd7
         6ZcYySPOds3k9hwY50RY7vQA2oHCX1C7H0hi0=
MIME-Version: 1.0
In-Reply-To: <20100523123801.GC950@n2100.arm.linux.org.uk>
References: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com>
	 <20100523123801.GC950@n2100.arm.linux.org.uk>
Date: Sun, 23 May 2010 21:44:20 +0800
Message-ID: <AANLkTikRp0EHxshKYq39p18ymoRNAtyHrNm3yq6A49-r@mail.gmail.com>
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
>>  ENTRY(ret_to_user)
>>  ret_slow_syscall:
>> -     disable_irq                             @ disable interrupts
>> +     disable_irq_notrace                             @ disable interrupts
>
> I think this one does need to be traced - the pending work functions are
> all C code which could call back into lockdep.

If there are pending works, schedule will be called to give cpu to it, I wonder
why the work function to be scheduled will be run with irq disabled.
Seems we should enable irq again before calling schedule, not sure.

> Also, I'm nervious about applying this patch without seeing more people
> test it.

I test the patch on my beagle board and is OK, and if you don't apply one
patch into your tree, there are few people who may test it since they have to
parse the raw email patch(which is more inconvenient than 'git pull') for test
if they want to do.

Thanks,
-- 
Lei Ming
