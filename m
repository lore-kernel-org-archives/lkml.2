Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab0EFPj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:39:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758849Ab0EFPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:39:24 -0400
Date: Thu, 6 May 2010 08:37:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: Resource limits interface proposal [was: pull request for 
 writable limits]
In-Reply-To: <m2jb6fcc0a1005052339h3dd5c77cwd762c65a23180638@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com>  <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org>  <20100321060607.GA4062@x200>  <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org>  <4BE160C6.90404@gmail.com> 
 <alpine.LFD.2.00.1005050757370.5478@i5.linux-foundation.org> <m2jb6fcc0a1005052339h3dd5c77cwd762c65a23180638@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 May 2010, Alexey Dobriyan wrote:

> On Wed, May 5, 2010 at 6:08 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Ok, I'm not entirely sure we need to care specially about INFINITY,
> > _especially_ since INF is really rather big in 64 bits. So to some degree,
> > making things 64-bit is _less_ likely to make INFINITIES a problem.
> 
> I'm _sure_, someone will mention bloat and performance degradation
> on 32-bit, so there will be config option for 32-bit in-kernel limits.
> And if there will be config option, infinities are better be separated.

Umm. Why?

Adding an INF field will make it essentially impossible to use that thing 
as a compatibility function, and/or together with the legacy rlimit() 
system call. And that is going to be 99.999% of all uses.

I don't think you understand how system calls work. People don't use 
Linux-only features. It's been shown over and over and over again. People 
use the standard interfaces, and they don't _have_ that INF field. We can 
extend ranges by just updating structures (see "stat()" and friends) and a 
recompile will make it use higher limits, but we can't make programs use 
new features.

So there is _no_ upside. There would be _no_ programs ever using it. 

Whether the internal limits for the kernel are 32-bit or not makes 
absolutely zero difference. And my argument is that _if_ they are 64-bit, 
that makes the INF field even _less_ interesting. So they go from "zero 
practical difference" in 32-bit to "f*ck it, nobody can _possibly_ care 
even in theory" in 64-bit.

If the internal limits are 32-bit, then you just turn any 64-bit value 
larger than the (32-bit) RLIM_INFINITY into a RLIM_INFINITY. And that's as 
good as you can get with mixing with the legacy interface anyway.

		Linus
