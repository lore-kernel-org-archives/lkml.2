Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0EXV3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 17:29:38 -0400
Received: from king.tilera.com ([72.1.168.226]:47559 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab0EXV3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 17:29:36 -0400
Message-ID: <4BFAEFBD.20500@tilera.com>
Date: Mon, 24 May 2010 17:29:33 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005240008.16497.arnd@arndb.de> <4BFA9B4E.9010200@tilera.com> <201005242053.25594.arnd@arndb.de>
In-Reply-To: <201005242053.25594.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2010 21:29:34.0913 (UTC) FILETIME=[348B0310:01CAFB88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/2010 2:53 PM, Arnd Bergmann wrote:
> I would also like to wait for another opinion before it goes in.
> Note that the regular procedure is to have the code reviewed
> before the start of the merge window, not in the middle of it!
>   

Ack!  My mistake, sorry.  I was under the impression that I should wait
for the churn on the list to die down a bit after the stable release (in
this case 2.6.34) before trying to send big batches of new code into LKML.

>>> Since the file is exported to user space, the map_cache stuff probably
>>> should not be here, but get moved to a different header that
>>> is private to the kernel.
>>>   
>>>       
>> It's part of the optional extended API for mmap() used by Tilera Linux,
>> so it is actually needed by userspace.
>>     
> Ah, that's unfortunate. How bad would it be for you to come up
> with a different ABI for the homecache version? I don't have all
> the facts but my feeling is that the mmap API should not be
> touched by this and that it better fits into an extension of the
> numa syscalls, specifically the set_mempolicy/mbind/move_pages
> family.
>   

Interesting idea.  I'll consider how straightforward this would be to do.

>> As for <asm-generic/unistd.h>, I'll look more carefully at it, though of
>> course using it is also dependent on whether it is reasonable for us to
>> completely break compatibility with current user-space programs.
>>     

I think the discussion internally supports breaking backwards
compatibility; this will after all be aligned with our 3.0 release
eventually, which is when we are also switching compilers to gcc.  So
I'll see what is involved in the kernel and libc in switching to
<asm-generic/unistd.h> and get back to you with more detailed comments
if necessary.

> Note that the asm-generic version defines 244 numbers, while you have
> a total of 313 numbers. You obviously need the extra arch specific
> syscalls (e.g cmpxchg), so we need to reserve some space for those
> in the generic header.

Yes, although cmpxchg is actually a negative syscall value, which we use
to save every last cycle on that path -- it doesn't do any of the usual
syscall processing at all, just basically takes advantage of the kernel
lock infrastructure.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


