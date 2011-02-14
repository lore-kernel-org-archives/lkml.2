Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1BNB7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 20:59:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53365 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1BNB7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 20:59:31 -0500
Message-ID: <4D588C67.5030205@zytor.com>
Date: Sun, 13 Feb 2011 17:59:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, x32-abi@googlegroups.com,
        "H.J. Lu" <hjl.tools@gmail.com>, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>	<AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>	<4D584A49.80306@zytor.com>	<201102132328.15360.arnd@arndb.de>	<4D585F5F.6030708@zytor.com> <20110213233926.1b3ca15a@lxorguk.ukuu.org.uk>
In-Reply-To: <20110213233926.1b3ca15a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 03:39 PM, Alan Cox wrote:
>> a. the int $0x80 instruction is much slower than syscall.  An actual
>>     i386 process can use the syscall instruction which is disambiguated
>>     by the CPU based on mode, but an x32 process is in the same CPU mode
>>     as a normal 64-bit process.
>
> So set a flag, whoopee

That's what we're doing, functionally.

>> b. 64-bit arguments have to be split between two registers for the
>>     i386 entry points, requiring user-space stubs.
>
> Diddums. Given you've yet to explain why everyone desperately needs this
> extra interface why do we care ?
>
>> All in all, the cost of an extra system call table is quite modest.
>
> And the cost of not doing it is a gloriously wonderful zero. Yo've still
> not explained the justification or what large number of apps are going to
> use it.
>
> It's a simple question - why do we care, why do we want the overhead and
> the hassle, what do users get in return ?

The target applications are an embedded (closed or mostly closed) 
environment, and the question is if the performance gain is worth it. 
It is an open question at this stage and we'll see what the numbers look 
like and, if it turns out to be worthwhile, what exactly the final 
implementation will look like.

	-hpa
