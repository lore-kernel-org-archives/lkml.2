Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1BMPhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:37:34 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48812 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1BMPh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:37:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AjrCYWHJfKGTA+KOQpRZSISjvwURID7Op5idKnndm2tiVAq1bHyv5OE0k9wdWxHdRf
         5A+JunG6xkK8wC/tVrK157JyvO67xLbAdI7X+4JQT2bj3pzaFYybDuRI1D7DHrUdDrnh
         f01ZVzwmltk//PNZipYtgp7Ag5G3CyDHCBRpc=
MIME-Version: 1.0
In-Reply-To: <877hd4j6ya.fsf@mid.deneb.enyo.de>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de>
	<4D5711E0.7020306@zytor.com>
	<87r5bcnwvw.fsf@mid.deneb.enyo.de>
	<AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
	<87tyg8j7le.fsf@mid.deneb.enyo.de>
	<AANLkTin1cTCVNTiLS792ZkG9_Y5OvXCtDXHRFfY7hbSF@mail.gmail.com>
	<877hd4j6ya.fsf@mid.deneb.enyo.de>
Date: Sun, 13 Feb 2011 07:37:28 -0800
Message-ID: <AANLkTi=Ou2-6wvwH4OD_NBtv5tvgWAnGV7TRer75N-Jk@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: x32-abi@googlegroups.com, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 7:21 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
> * H. J. Lu:
>
>> On Sun, Feb 13, 2011 at 7:07 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
>>> * H. J. Lu:
>>>
>>>>> Actually, I'm wondering if you can do the translation in user space.
>>>>> There already are 32-on-64 implementations in existence, without
>>>>> kernel changes (recent Hotspot, LuaJIT, and probably some more).
>>>>
>>>> Please check out the x32 kernel source and provide feedback.
>>>
>>> I still don't understand why you need a separate syscall table.  You
>>> should really be able to run on an unmodified amd64 kernel, in 64 bit
>>
>> That is done on purpose. x32 is designed for environments where the
>> current ia32 API is sufficient. You can think it as ia32 with register
>> extended to 64bit plus 8 more registers. Everything else is still 32bit.
>
> I think of it as amd64 where all the process memory happens to reside
> in the first 4 GB of address space, and pointers are stored as 32 bits
> (and you'd also reduce the size of longs because sizeof(long) !=
> sizeof(void *) will break too many programs).

That is what the processor sees in an x32 program.

> As I said, both LuaJIT and Hotspot are already using this model, with
> custom memory allocators and a user-space translation layers, so I
> still don't see what you get by changing the kernel.  LuaJIT has even
> implemented the amd64 ABI, so you can call C libraries from your
> 32-bit code.  (Note that LuaJIT uses 64-bit words to store 32-bit
> pointers with several tag bits, but it does so even on pure 32-bit
> platforms.)

They can continue to do so.

> If you want to make x32 closer to i386, I don't see the point.  Why
> would it be problematic if it was as close to i386 as, say, armel?
>

We are providing a 32bit API with 64bit registers. Current APIs support
either 32bit or 64bit.  I am not talking about pointer or long. I am talking
other types, like time_t, off_t, ..., defined by API.  Adding another API
is extremely difficult.

-- 
H.J.
