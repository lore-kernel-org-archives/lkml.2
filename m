Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0FDCAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:00:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756821Ab0FDCAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:00:32 -0400
Date: Thu, 3 Jun 2010 18:55:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006041032.04323.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006031851301.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006031450.53576.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006030916520.8175@i5.linux-foundation.org> <201006041032.04323.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jun 2010, Rusty Russell wrote:
> > 
> > At least call it "struct module_load_info". But yes, I do agree that the 
> > "load" part is important.
> 
> Looking at the arch code, it has the advantage that it's self-contained.
> They've been pleasantly undemanding from the core over the years; I think
> archs doing tricky things with elf prefer to parse the object themselves
> anyway.  And I'm not sure they want to revisit it, either.
> 
> So I don't think we'd win much from changing them.  I'm wrong later, I'll
> prepend "module_" to the struct name as an internal change then hit them
> all.

Ok. So if we don't expect to ever pass the full load_info struct down to 
the arch code, and we can keep it entirely internal to module.c, then 
"struct load_info" is fine by me.

> If so, do you want just the fixes or the whole refactoring too, while
> it's nice and fresh?

Gaah. "Just the fixes" is definitely the prudent thing to do. At the same 
time, I've now so deeply bought into the whole cleanup thing too, that I 
want to argue that the cleanup might make it easier to handle any locking 
problems if we find them.

But I suspect that is just myself trying to fool/argue my smarter half 
into taking it all.

So you can probably push me either way.

			Linus
