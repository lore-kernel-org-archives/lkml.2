Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1ABJJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:09:13 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38213 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881Ab1ABJJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:09:12 -0500
Date: Sun, 2 Jan 2011 10:09:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Security] proactive defense: using read-only memory
Message-ID: <20110102090911.GU32469@atrey.karlin.mff.cuni.cz>
References: <20101107193520.GO5327@outflux.net> <20101117100053.GA1574@ucw.cz> <20101117221443.GR13854@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117221443.GR13854@outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > - Pointers to function table also need to be marked read-only after
> > >   they are set. An example of this is the security_ops table pointer. It
> > >   gets set once at boot, and never changes again. These need to be handled
> > >   so it isn't possible to just trivially reaim the entire security_ops
> > >   table lookup somewhere else.
> > 
> > But there are too many of those. You can't block them all...
> 
> Well, I don't think "too many" is a good reason. And I think it is possible
> to block them all if we're careful and diligent. Maybe I'm naive;
>   we'll see.

I believe "too many" is very good reason -- you do not want to uglify
the kernel too badly.

It is not like anything that makes attackers life harder is a good
thing... for example deleting all the comments would clearly make
attacking linux harder, but it is also clearly bad idea. 

> > > - Entry points to set_kernel_text_rw() and similar need to be blockable.
> > >   Having these symbols available make kernel memory modification trivial;
> > 
> > What prevents attacker to just inlining those functions in the
> > exploit?
> 
> The goal is to make it harder for an attacker to create, change, or hide
> kernel code in memory. If they're able to already execute arbitrary code,
> then yes, it's doesn't change anything. But the point is to make it harder
> to get to that point to start with.

So... what do you assume attacker _can_ do? What is it you are trying
to protect against?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
