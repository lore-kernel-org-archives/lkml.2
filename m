Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1BMVRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 16:17:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56595 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab1BMVRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 16:17:18 -0500
Message-ID: <4D584A49.80306@zytor.com>
Date: Sun, 13 Feb 2011 13:16:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: x32-abi@googlegroups.com
CC: "H.J. Lu" <hjl.tools@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>	<201102132110.29630.arnd@arndb.de> <AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>
In-Reply-To: <AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 01:10 PM, H.J. Lu wrote:
>>>
>>> 1. Kernel interface with syscall is close to be finalized.
>>

I don't think calling it "finalized" is accurate... it is more
accurately described as "prototyped".

>> Really? I haven't seen this being posted for review yet ;-)
>>
>> The basic concept looks entirely reasonable to me, but I'm
>> curious what drove the decision to start out with the x86_64
>> system calls instead of the generic ones.
>>
>> Since tile was merged, we now have support for compat syscalls
>> in the generic syscall ABI. I would have assumed that it
>> was possible to just use those if you decide to do a new
>> ABI in the first place.
>> 
>> The other option that would have appeared natural to me is
>> to just use the existing 32 bit compat ABI with the few
>> necessary changes done based on the personality.

The actual idea is to use the i386 compat ABI for memory layout, but
with a 64-bit register convention.  That means that system calls that
don't make references to memory structures can simply use the 64-bit
system calls, otherwise we're planning to reuse the i386 compat system
calls, but invoke them via the syscall instruction (which requires a new
system call table) and to pass 64-bit arguments in single registers.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

