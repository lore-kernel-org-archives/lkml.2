Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1BMWrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:47:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42309 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab1BMWrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:47:17 -0500
Message-ID: <4D585F5F.6030708@zytor.com>
Date: Sun, 13 Feb 2011 14:46:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: x32-abi@googlegroups.com, "H.J. Lu" <hjl.tools@gmail.com>,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com> <AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com> <4D584A49.80306@zytor.com> <201102132328.15360.arnd@arndb.de>
In-Reply-To: <201102132328.15360.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 02:28 PM, Arnd Bergmann wrote:
> On Sunday 13 February 2011, H. Peter Anvin wrote:
>> The actual idea is to use the i386 compat ABI for memory layout, but
>> with a 64-bit register convention.  That means that system calls that
>> don't make references to memory structures can simply use the 64-bit
>> system calls, otherwise we're planning to reuse the i386 compat system
>> calls, but invoke them via the syscall instruction (which requires a new
>> system call table) and to pass 64-bit arguments in single registers.
> 
> As far as I know, any task can already call both the 32 and 64 bit syscall
> entry points on x86. Is there anything you can't do just as well by
> using a combination of the two methods, without introducing a third one?

We prototyped using the int $0x80 system call entry point.  However,
there are two disadvantages:

a. the int $0x80 instruction is much slower than syscall.  An actual
   i386 process can use the syscall instruction which is disambiguated
   by the CPU based on mode, but an x32 process is in the same CPU mode
   as a normal 64-bit process.
b. 64-bit arguments have to be split between two registers for the
   i386 entry points, requiring user-space stubs.

All in all, the cost of an extra system call table is quite modest.  The
cost of an entire different ABI layer (supporting a new memory layout)
would be enormous, a.k.a. "not worth it", which is why the memory layout
of kernel objects needs to be compatible with i386.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

