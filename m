Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1BMPW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:22:27 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:48940 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1BMPWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:22:22 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: x32-abi@googlegroups.com, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de> <4D5711E0.7020306@zytor.com>
	<87r5bcnwvw.fsf@mid.deneb.enyo.de>
	<AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
	<87tyg8j7le.fsf@mid.deneb.enyo.de>
	<AANLkTin1cTCVNTiLS792ZkG9_Y5OvXCtDXHRFfY7hbSF@mail.gmail.com>
Date: Sun, 13 Feb 2011 16:21:49 +0100
In-Reply-To: <AANLkTin1cTCVNTiLS792ZkG9_Y5OvXCtDXHRFfY7hbSF@mail.gmail.com>
	(H. J. Lu's message of "Sun, 13 Feb 2011 07:13:57 -0800")
Message-ID: <877hd4j6ya.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. J. Lu:

> On Sun, Feb 13, 2011 at 7:07 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
>> * H. J. Lu:
>>
>>>> Actually, I'm wondering if you can do the translation in user space.
>>>> There already are 32-on-64 implementations in existence, without
>>>> kernel changes (recent Hotspot, LuaJIT, and probably some more).
>>>
>>> Please check out the x32 kernel source and provide feedback.
>>
>> I still don't understand why you need a separate syscall table.  You
>> should really be able to run on an unmodified amd64 kernel, in 64 bit
>
> That is done on purpose. x32 is designed for environments where the
> current ia32 API is sufficient. You can think it as ia32 with register
> extended to 64bit plus 8 more registers. Everything else is still 32bit.

I think of it as amd64 where all the process memory happens to reside
in the first 4 GB of address space, and pointers are stored as 32 bits
(and you'd also reduce the size of longs because sizeof(long) !=
sizeof(void *) will break too many programs).

As I said, both LuaJIT and Hotspot are already using this model, with
custom memory allocators and a user-space translation layers, so I
still don't see what you get by changing the kernel.  LuaJIT has even
implemented the amd64 ABI, so you can call C libraries from your
32-bit code.  (Note that LuaJIT uses 64-bit words to store 32-bit
pointers with several tag bits, but it does so even on pure 32-bit
platforms.)

If you want to make x32 closer to i386, I don't see the point.  Why
would it be problematic if it was as close to i386 as, say, armel?
