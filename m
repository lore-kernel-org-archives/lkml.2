Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab0F1EF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 00:05:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:47228 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0F1EFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 00:05:54 -0400
Message-ID: <4C281F8C.9060006@windriver.com>
Date: Sun, 27 Jun 2010 23:05:32 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>, David Howells <dhowells@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Implement the GDB remote protocol 'p' command to
 retrieve a register
References: <20100609161909.18222.78028.stgit@warthog.procyon.org.uk>	<alpine.LFD.2.00.1006090945531.4506@i5.linux-foundation.org> <y0mfx0wysiq.fsf@fche.csb>
In-Reply-To: <y0mfx0wysiq.fsf@fche.csb>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2010 04:05:33.0316 (UTC) FILETIME=[27B31C40:01CB1677]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 01:23 PM, Frank Ch. Eigler wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>   
>>> Implement the GDB remote protocol 'p' command to retrieve a single register
>>> value.
>>>       
>> Is there any value to this? [...]
>>     
>
> Sure, much less data to transfer across a slowish serial link.
>
>   

I have actually measured this before using a yet to be posted for review
version which works for x86, arm and mips.   The improvement is more
significant with the 64 bit archs vs the 32 because of the register
sizing.  The typical case of stepping is quite a bit more responsive
when you only need to read the pc, stack pointer and frame pointer.  At
the point in time I post the patches, I can also post the data about the
savings for two of the exact same work load sequences.

I had also tried out an implementation of the gdb extension which where
you can pass the pc, stack pointer and frame pointer along with the stop
code and this provides an additional speed up as well, but not nearly as
much of a gain as implementing the 'p' packets.

I don't know if I will have it ready for 2.6.36 or not, but the generic
use of the 'p' packet was also required so that the kdb shell could have
a mechanism to individually read and write registers.

I am a bit curious if the frv arch had considered migrating to the kgdb
core, vs continuing to use the separate gdbstub?   It would seem we are
duplicating the creation of the same sort of features.  The frv
architecture may not need it at all, but if you do make use of the kgdb
core, you get other features like kdb for free, plus any of the
interesting features you might want to add might be of interest to other
consumers of the kernel debugger.

Cheers,
Jason.
