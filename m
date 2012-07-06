Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2GFNBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:01:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37310 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab2GFNBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:01:47 -0400
Date: Fri, 6 Jul 2012 09:01:27 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
Message-ID: <20120706130127.GB10798@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	w@1wt.eu, ewust@umich.edu, zakir@umich.edu, greg@kroah.com,
	nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
	davem@davemloft.net, stable@kernel.org
References: <1341511933-11169-2-git-send-email-tytso@mit.edu>
 <1341514078.4020.1213.camel@calx>
 <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
 <1341524367.4020.1324.camel@calx>
 <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
 <20120705220040.GA15685@thunk.org>
 <CA+55aFzFMZpiDMJO9UxoXSjOCzvxn7tgvmAHLM36OmaiMasQhw@mail.gmail.com>
 <1341527482.4020.1355.camel@calx>
 <20120705232136.GD15685@thunk.org>
 <CA+55aFxhobNMY5RLmH+tKox8voqfH-bVqKVF03JeeVrHkhLcaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxhobNMY5RLmH+tKox8voqfH-bVqKVF03JeeVrHkhLcaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 07:59:00PM -0700, Linus Torvalds wrote:
> On Thu, Jul 5, 2012 at 4:21 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Thu, Jul 05, 2012 at 05:31:22PM -0500, Matt Mackall wrote:
> >>
> >> It's better to mix and not credit than to not mix at all. Instead just
> >> check the fast count against HZ before the credit.
> >
> > I'm not sure what you mean by this?
> 
> So what I think Matt meant was to check number of timer interrupts
> against the fast count.
> 
> IOW, always call "add_interrupt_randomness()", but then in that
> function, when you determine the amount of entropy, check if there
> were non-timer interrupts in the last HZ cycle. If there were purely
> timer interrupts, you can still mix in the cycle information, but it's
> likely to be fairly weak.

I'm going to have to plead ignorance to how the timer code works these
days.  With the advent of clockevents and NOHZ, it's gotten a lot more
complicated.  What in the world is "fast count"?  I've grepped for it,
and I can't find it.

I can simply not credit entropy of the timer is on the irq, but I
think you and Matt were suggesting more subtle.  I just have no idea
how to tell if there were non-timer interrupts during the last HZ
cycle.  Can you give me a hint?

Thanks,

						- ted
