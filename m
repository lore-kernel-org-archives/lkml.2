Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1LAPFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:05:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64065 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab1LAPFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:05:19 -0500
MIME-Version: 1.0
In-Reply-To: <D70E8CC4-9FA3-4DC9-B623-02F32EFBFE0F@kernel.crashing.org>
References: <CAL8zT=juU_PC92R4za31R8Lmur0PrFwog1m1fk+PEarW_0C6ng@mail.gmail.com>
 <D70E8CC4-9FA3-4DC9-B623-02F32EFBFE0F@kernel.crashing.org>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Thu, 1 Dec 2011 16:04:57 +0100
Message-ID: <CAL8zT=gGfBYsLcsKobJPhfhEhNeLcrYMoWh2kv0odT0n0wnZgQ@mail.gmail.com>
Subject: Re: Different behaviour when using "nosmp" parameter on SMP and UP
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/1 Kumar Gala <galak@kernel.crashing.org>:
>
> On Dec 1, 2011, at 3:57 AM, Jean-Michel Hautbois wrote:
>
>> Hi,
>>
>> I have a P2020 CPU (powerpc) and I compiled it with two different defconfigs.
>> The first one is a SMP, 2 cores, launched with the "nosmp" kernel
>> parameter, the other one is an UP kernel.
>>
>> My driver behaviour is not the same whether launching one or the
>> other. It is hard to explain more precisely, as it deals only with
>> ioctl which only does ioread32/iowrite32 on a PCIe device.
>> But I can tell that it never works the same way when UP (not working
>> correctly), or SMP "nosmp" (working) or even SMP (not working).
>>
>> AFAIK, the "nosmp" parameter should tell the kernel to act the same is
>> if it is an UP kernel, and it disables IO APIC, which is not an issue
>> in my case.
>>
>> Can you think about anything that would explain it, or would help me
>> debugging it ?
>
> This is a bit odd, hard to say w/o more details on what exactly your code is trying to do and wait the failure is.

I understand that it is difficult to give more details, but the driver
is not mine, and I can't give all the code associated.

> The larger differences between SMP & UP build would be setting of memory attribute for cache coherency.  In UP case we don't set it.
>
> Between SMP 'nosmp' and SMP 'on' cases you seem like you're hitting some locking condition.
>
> Guessing your running into a timing & locking issue that you're getting lucky on the SMP 'nosmp' case such that it just happens to work.

Any idea on how to debug this ? I am using a 2.6.35 kernel.

Thanks,
JM
