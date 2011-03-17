Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1CQOnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:43:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49020 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1CQOnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:43:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tdRUGCreMxD118zVvzrQ0TzC43OHpONVxYjoK+DxI8rOBxAvGJt53io18TC8r8kV4A
         GZI03Tv5+ikoLe75eHh7hLvn0yEoYoX2UBBerVnpql1IzjFXh4VRXTApzrsKG+ZLoTu9
         13km9UMzWUavh6xCQ/GrxVHBPQ5/K6wWX19NE=
MIME-Version: 1.0
In-Reply-To: <201103170145.46326.vapier@gentoo.org>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
	<201103162257.10440.vapier@gentoo.org>
	<AANLkTikfiVvxrxakH-_pch6v0jkT1yZstw4kXShyx+Sd@mail.gmail.com>
	<201103170145.46326.vapier@gentoo.org>
Date: Thu, 17 Mar 2011 07:43:50 -0700
Message-ID: <AANLkTikWyEzxDsjAEcR71fth+558qEA6HZ0PX64V+V0v@mail.gmail.com>
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

On Wed, Mar 16, 2011 at 10:45 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Thursday, March 17, 2011 01:21:16 H.J. Lu wrote:
>> On Wed, Mar 16, 2011 at 7:57 PM, Mike Frysinger <vapier@gentoo.org> wrote:
>> > ok, took long enough, but that answers most things.  your usage of "x32-"
>> > prefixed binaries in the documentation seems to imply a lot more than the
>> > fact you just picked those locally to avoid system collisions.  this
>> > isnt a wiki page, otherwise i'd clean things up for you.
>>
>> Any suggestion how to create a wiki page for x32?
>
> seems like the sites.google.com documentation says it includes wiki support.
>        http://sites.google.com/site/projectwikitemplate_en/
>
> ive never used google sites before, so i dont know how to actually enable it
> on the admin side of things.

I will take a look.

>> > in looking at the gcc files, it doesnt seem like there's any defines
>> > setup to declare x32 directly.  instead, you'd have to do something
>> > like: #ifdef __x86_64__
>> > # if __SIZEOF_LONG__ == 8
>> > /* x86_64 */
>> > # else
>> > /* x32 */
>> > # endif
>> > #endif
>> >
>> > any plans on adding an __x32__ (or whatever) cpp symbol to keep people
>> > from coming up with their own special/broken crap ?  or are there some
>> > already that i'm not seeing ?
>>
>> The idea is in most cases, you only need to check __x86_64__ since x32 and
>> x86-64 are very close.  In some cases, x32 is very different from x86_64,
>> like assembly codes on long and pointer, you can check __x86_64__ and
>> __LP64__. In glibc, I used a different approach by using macros REG_RAX,
>> .., MOV_LP, ADD_LP, SUB_LP and CMP_LP in assembly codes.
>
> arm/mips/ppc sets up explicit ABI defines to clearly differentiate between
> things.  while __LP64__ should work here, it seems like a poor substitute.
> how about builtin_define("__X32__") ?  or __ABI_X32__ ?  doesnt seem like i386
> has a standard in this regard to piggy off of.

If you can show me some real examples how __x32__ will be used, I will
take a look.

Thanks.

-- 
H.J.
