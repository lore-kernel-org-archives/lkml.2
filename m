Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0IMQVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:21:10 -0400
Received: from ist.d-labs.de ([213.239.218.44]:36051 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab0IMQVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:21:09 -0400
Date: Mon, 13 Sep 2010 18:21:05 +0200
From: Florian Mickler <florian@mickler.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: don't compile with gcc-3.3.3
Message-ID: <20100913182105.7463dd99@schatten.dmk.lab>
In-Reply-To: <4C8E49B7.7040104@zytor.com>
References: <1284366708-30154-1-git-send-email-florian@mickler.org>
	<1284367195.2275.29.camel@laptop>
	<4C8E49B7.7040104@zytor.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 08:56:39 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 09/13/2010 01:39 AM, Peter Zijlstra wrote:
> > On Mon, 2010-09-13 at 10:31 +0200, florian@mickler.org wrote:
> >> hpa commented on bug 16506[1] :
> >> "Please note that gcc-3.3.3 is known broken on x86; gcc-3.4 is the oldest
> >> version which is known to *not* be broken."
> >>
> >> References: 
> >> 	[0]: https://bugzilla.kernel.org/show_bug.cgi?id=16633
> >> 	[1]: https://bugzilla.kernel.org/show_bug.cgi?id=16506#c28
> >>
> >> If that is indeed so, we should abort the build? No?
> > 
> > Does it in fact still build with 3.4? I seem to recall some talk about
> > pushing the minimum version to 4.x for x86, although I can't remember
> > where..
> 
> It does indeed still build with 3.4, although it is giving us a bunch of
> headaches to *make it so*, and I would personally be really glad if the
> consensus is we can just axe it.
> 
> The only reason to not abort the build for gcc 3.3.3 is that soem
> "enterprise" distros have been shipping gcc 3.3.3 with backported fixes
> from 3.4, which of course still identifies themselves as gcc 3.3.3, and
> so technically it is iompossioble to tell if any particular "gcc 3.3.3"
> is actually broken or not.
> 
> However, as far as I can tell, most of the people who build current x86
> kernels with gcc 3.x are people who are testing building current kernels
> with gcc 3.x.  Some of the embedded systems are different, because for
> some strange reasons most of the embedded world seem stuck on gcc 3.4 or so.

Well, all _I_ can add, that there are people (2 I know
from the above bug reports to be precise) who spent hours (? well I
guess, at least some minutes) debugging old gcc bugs and just to have
some (please take no offense, I'm just trying to tell how it must look
to them) random guy tell them in the bugzilla "na na, we know about this
already and we don't fix it, na na" ...

Also the patch above checks actually for 4.4.3 which is obvioulsy
wrong ;) 

The enterprise distro issue is a little bit of an annoyance.. but they
should perhaps give us an opportunity to distinguish between their
(working) gcc and the stock broken one. I'm totally not opposed to any
ugly hack to make that distinguishing over here. But not fixing the
issues above seems to hurt the mainline linux kernel.

Cheers,
Flo

> 
> 	-hpa
> 
