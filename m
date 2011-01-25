Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1AYMYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:24:17 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54001 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1AYMYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:24:15 -0500
MIME-Version: 1.0
In-Reply-To: <bb0c3855a121603232d022b4062752a6@mail.gmail.com>
References: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com>
	<8yad3nlh18e.fsf@huya.qualcomm.com>
	<AANLkTin9fSw5DdqdgCEvtdtc83LFOeA7t0OAUugVmRFD@mail.gmail.com>
	<20110125102652.GB11507@n2100.arm.linux.org.uk>
	<bb0c3855a121603232d022b4062752a6@mail.gmail.com>
Date: Tue, 25 Jan 2011 12:24:13 +0000
Message-ID: <AANLkTi=vZSZkN2k1gZD0F-C74b_jFWX5HhDhr7BiPhN7@mail.gmail.com>
Subject: Re: questions about arm trustzone
From: Dave Martin <dave.martin@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        sen wang <wangchendu@gmail.com>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:46 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
>> -----Original Message-----
>> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-
>> arm-kernel-bounces@lists.infradead.org] On Behalf Of Russell King -
>> ARM Linux
>> Sent: Tuesday, January 25, 2011 3:57 PM
>> To: sen wang
>> Cc: David Brown; linux-kernel@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org
>> Subject: Re: questions about arm trustzone
>>
>> On Tue, Jan 25, 2011 at 05:19:16PM +0800, sen wang wrote:
>> > It seems linux run in the normal world, and the "scm.c"  is the
>> path
>> > to the monitor mode.
>> > where can I find the example code for monitor and secure world?
>>
>> OMAP also uses smc: arch/arm/mach-omap2/omap44xx-smc.S
>>
>> There's no interface defined for smc because it's highly vendor and
>> implementation specific.  It's just like a SWI (or svc) where it
>> causes entry via a vector into a priviledged mode, which can be
>> thought of being similar to a branch to a vector with a mode switch.
>>
> The code above won't give major details of how the monitor mode is
> implemented.  But as Russell said, it's pretty much vendor specific.
>
> On OMAP, We have standard API interfaces to enter into monitor
> world. One of the parameter denotes the kind of service, is
> requested.

I'm going off on a bit of a tangent here, but do you know whether the
Secure World code on OMAP can cope with being called from Thumb?  In
particular, if the Secure World tries to read the comment field from
the SMC instruction (which I notice is non-zero in some cases for
OMAP), it would need to be specifically coded to cope with the Thumb
case for this to work.

Avoiding this complexity is one of the motivations for using r7 for
the syscall number with CONFIG_EABI (instead of using the SVC comment
field).

Currently in my efforts to get the OMAP kernel working in Thumb-2, I
have assumed for simplicity that the Secure World will choke on SMCs
from Thumb code, but it would be nice to minimise the amount of code
which we need to build as ARM in the CONFIG_THUMB2_KERNEL case.  In
principle, everything could be Thumb code, now that the SWP
instruction usage is gone.

Cheers
---Dave
