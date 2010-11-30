Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0K3Skl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:40:41 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:37737 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052Ab0K3Skk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:40:40 -0500
Message-ID: <4CF54527.2070609@vmware.com>
Date: Tue, 30 Nov 2010 10:40:39 -0800
From: Michael Snyder <msnyder@vmware.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101103)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Mark Wielaard <mjw@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Hui Zhu <teawater@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>,
        "hellogcc@freelists.org" <hellogcc@freelists.org>
Subject: Re: [PATCH] Built kernel without -O2 option
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com> <87r5e4lab7.fsf@basil.nowhere.org> <1291025536.2904.6.camel@springer.wildebeest.org> <20101130093106.GD5203@cr0.nay.redhat.com>
In-Reply-To: <20101130093106.GD5203@cr0.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Mon, Nov 29, 2010 at 11:12:16AM +0100, Mark Wielaard wrote:
>> On Mon, 2010-11-29 at 10:59 +0100, Andi Kleen wrote:
>>> Hui Zhu <teawater@gmail.com> writes:
>>>
>>>> Now, there are a lot of ways to debug the Linux kernel with GDB, like
>>>> qemu, kgtp or kgdb and so on.
>>>> But the developer more like add a printk. It have a lot of reason, a big one is:
>>>> (gdb) p ret
>>>> $3 = <value optimized out>
>>>> And the code execution order is not right.
>>> Really the right place to fix a lot of this would be gcc (and perhaps
>>> gdb). I suspect with some careful work the debugging experience
>>> for -O2 could be improved a lot.
>>> I also believe the latest gccs already have improvements in this area.
>> The VTA branch was merged for GCC 4.5
>> http://gcc.gnu.org/wiki/Var_Tracking_Assignments
>> Which helps a lot with generating dwarf for previously "optimized out"
>> values. There were also a couple of papers on generating even better
>> debuginfo at the recent GCC Summit: http://gcc.gnu.org/wiki/summit2010
>>
>> Jakub Jelínek, Improving debug info for optimized away parameters
>> http://gcc.gnu.org/wiki/summit2010?action=AttachFile&do=get&target=jelinek.pdf
>> Alexandre Oliva, Consistent Views at Recommended Breakpoints
>> http://gcc.gnu.org/wiki/summit2010?action=AttachFile&do=get&target=oliva.pdf
>>
> 
> Cool! It would be much more convenient if this is solved by gcc.

Those features mentioned at the GCC summit are not real close to 
completion.  I wouldn't put off the discussion just because they're
(possibly) in the pipeline.

