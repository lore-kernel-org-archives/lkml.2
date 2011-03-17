Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1CQFVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 01:21:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41491 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1CQFVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 01:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ukxr5UmBzs/MmHIesxIziHpK5C+6BZg9z8aPNQw2rKWHUO3+ZVpMGa0agonLmXfBPB
         PkPfKYIR4uCDWC32+VnJfH1vZd4E8IezrgwHlASuVPdvOk4wAqs4njuTMde+as2cZQUW
         C2Ds1/3WTAxjW86NbdrIDjtqVGXZZhu1iNCc4=
MIME-Version: 1.0
In-Reply-To: <201103162257.10440.vapier@gentoo.org>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
	<201103160124.42939.vapier@gentoo.org>
	<AANLkTim4w7zBBnsu+A1TMtb-wv60urDiSk5T0qbg7Oze@mail.gmail.com>
	<201103162257.10440.vapier@gentoo.org>
Date: Wed, 16 Mar 2011 22:21:16 -0700
Message-ID: <AANLkTikfiVvxrxakH-_pch6v0jkT1yZstw4kXShyx+Sd@mail.gmail.com>
Subject: Re: X32 psABI status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: libc-alpha@sourceware.org, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 7:57 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Wednesday, March 16, 2011 08:39:57 H.J. Lu wrote:
>> On Tue, Mar 15, 2011 at 10:24 PM, Mike Frysinger wrote:
>> > so we get back to my original e-mail:
>> >        are you getting a unique host tuple for this ?  or are you
>> > extending x86_64-linux-gnu ?  so the only way of knowing which ABI is to
>> > check for the output of the compiler+compiler flags ?
>>
>> As I said, the target is x86_64- linux-gnu and you just add -mx32 to
>> CFLAGS. The x86_64- linux-gnu binutils and GCC support  x32.
>
> ok, took long enough, but that answers most things.  your usage of "x32-"
> prefixed binaries in the documentation seems to imply a lot more than the fact
> you just picked those locally to avoid system collisions.  this isnt a wiki
> page, otherwise i'd clean things up for you.

Any suggestion how to create a wiki page for x32?

> in looking at the gcc files, it doesnt seem like there's any defines setup to
> declare x32 directly.  instead, you'd have to do something like:
> #ifdef __x86_64__
> # if __SIZEOF_LONG__ == 8
> /* x86_64 */
> # else
> /* x32 */
> # endif
> #endif
>
> any plans on adding an __x32__ (or whatever) cpp symbol to keep people from
> coming up with their own special/broken crap ?  or are there some already that
> i'm not seeing ?

The idea is in most cases, you only need to check __x86_64__ since x32 and
x86-64 are very close.  In some cases, x32 is very different from x86_64, like
assembly codes on long and pointer, you can check __x86_64__ and __LP64__.
In glibc, I used a different approach by using macros REG_RAX, .., MOV_LP,
ADD_LP, SUB_LP and CMP_LP in assembly codes.

I added a simple howto for x32 compiling to

https://sites.google.com/site/x32abi/

Thanks.

-- 
H.J.
