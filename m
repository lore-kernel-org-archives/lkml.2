Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1AYMgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:36:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49703 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1AYMgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:36:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WoBs6YuYU+HZ1hkqPCYw2PEGoq4YGh0eWoreS9wXW69uPMkPn4vdj8/n+R4ojBgiHp
         OlbLZCj0dURVveNBu45Fhsihxylx20RGpWj7MtNwMPwk764niwlLo/W8ch4Lg5G+kHq9
         fS22ly+v6h+ElQ1d59R6U3zVDVhCPWMMSL0jw=
MIME-Version: 1.0
In-Reply-To: <4D3DFBB0.90402@free.fr>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
	<1290431008.2072.119.camel@laptop>
	<1290443379.4cea9a73cd9ce@imp.free.fr>
	<1290443758.2072.318.camel@laptop>
	<20101122164247.GC21836@basil.fritz.box>
	<20101123235527.54293b59@mat-laptop>
	<20101126183144.300a71a4@mat-laptop>
	<1291093230.2405.191.camel@minggr.sh.intel.com>
	<1291116438.32004.649.camel@laptop>
	<1291162504.2405.216.camel@minggr.sh.intel.com>
	<4D3C7C36.903@free.fr>
	<4D3DFBB0.90402@free.fr>
Date: Tue, 25 Jan 2011 20:36:52 +0800
Message-ID: <AANLkTikk1JrB0KxryVruUe2DT304YZ-gk1j72bdZchgu@mail.gmail.com>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection
 for kernel data)
From: Lin Ming <minggr@gmail.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 6:22 AM, matthieu castet
<castet.matthieu@free.fr> wrote:
> matthieu castet a écrit :
>>
>> Lin Ming a écrit :
>>>
>>> On Tue, 2010-11-30 at 19:27 +0800, Peter Zijlstra wrote:
>>>>
>>>> On Tue, 2010-11-30 at 13:00 +0800, Lin Ming wrote:
>>>>>
>>>>> echo 0 > /sys/devices/system/cpu/cpu1/online;
>>>>> echo 1 > /sys/devices/system/cpu/cpu1/online;
>>>>>
>>>>> then machine just reboots...
>>>>>
>> I tried to do the same thing on qemu, and the same behavior happened (ie
>> reboot when resuming cpu1).
>>
>> After enabling qemu log, I found that a triple fault was happening at the
>> beginning of secondary_startup_64
>> when doing "addq phys_base(%rip), %rax".
>>
>> Why ?
>> I suppose because we access data set to NX, but we don't have enabled yet
>> NX in the msr. So the cpu crash due to "reserved bit check".
>>
>> If we enable NX before reading data, there is no more crash (patch
>> attached).
>>
>> Now I am not sure this is the correct fix. I think the problem is that
>> trampoline using kernel page table
>> is very dangerous. The kernel can have modified them atfer booting !
>> May be all the paging stuff should have been done in head_64.S. A first
>> one with identity mapping, and the second one for
>> the real kernel stuff.
>>
> Lin, could you try this patch on your x64 machine.

Hi,

I'm on holiday now.
I'll test it when I'm back on Feb 9.

Thanks,
Lin Ming

>
>
> Thanks
>
> Matthieu
>
