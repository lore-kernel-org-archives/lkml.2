Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993466Ab2KOOmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:42:18 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58113 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993440Ab2KOOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:42:16 -0500
MIME-Version: 1.0
In-Reply-To: <201211151436.23088.arnd@arndb.de>
References: <201211141218.02105.arnd@arndb.de>
	<201211150914.22835.arnd@arndb.de>
	<CAMe9rOpziKa6QLfjX9iXtfj_X2QAyDAV2p8NEd8Wd7yFwTrpNg@mail.gmail.com>
	<201211151436.23088.arnd@arndb.de>
Date: Thu, 15 Nov 2012 06:42:16 -0800
Message-ID: <CAMe9rOqvEFp=J-93WVgmF9K-hspq4z444a8PCJWC3tiSRkteOg@mail.gmail.com>
Subject: Re: new architectures, time_t __kernel_long_t
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 6:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 15 November 2012, H.J. Lu wrote:
>> On Thu, Nov 15, 2012 at 1:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Wednesday 14 November 2012, H. Peter Anvin wrote:
>> >> On 11/14/2012 04:18 AM, Arnd Bergmann wrote:
>> >> > Since we are in the review phase for two new architectures that we
>> >> > should be merging into the mainline kernel, I think we need to
>> >> > come up with a solution for making them use a proper 64-bit time_t.
>> >> >
>> >> > Right now, the only 32-bit user space interface we have to use 64-bit
>> >> > time_t is the x32 side of x86-64, and that works by overriding all
>> >> > "long" sized types to be 64 bit at the ABI level, which we don't
>> >> > want for pure 32 bit architectures.
>> >>
>> >> Sort of.  Either way, the kernel headers aren't really x32-clean yet, so
>> >> we have an opportunity to do things more cleanly as we are implementing
>> >> this.
>> >
>> > Ah, I didn't know that. How does one build an x32 libc then?
>>
>> Glibc has been providing its own types for years.
>> Kernel provided types used to be wrong for ia32
>> on x86-64.
>
> What about ioctls and other calls then that actually do rely on the
> kernel headers and use the __kernel_*_t types?
>

Glibc defines __syscall_slong_t and __syscall_ulong_t.

-- 
H.J.
