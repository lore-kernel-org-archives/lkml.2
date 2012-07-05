Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab2GEWb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:31:26 -0400
Received: from waste.org ([173.11.57.241]:37513 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab2GEWbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:31:25 -0400
Message-ID: <1341527482.4020.1355.camel@calx>
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Date: Thu, 05 Jul 2012 17:31:22 -0500
In-Reply-To: <CA+55aFzFMZpiDMJO9UxoXSjOCzvxn7tgvmAHLM36OmaiMasQhw@mail.gmail.com>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
	 <1341511933-11169-2-git-send-email-tytso@mit.edu>
	 <1341514078.4020.1213.camel@calx>
	 <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
	 <1341524367.4020.1324.camel@calx>
	 <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
	 <20120705220040.GA15685@thunk.org>
	 <CA+55aFzFMZpiDMJO9UxoXSjOCzvxn7tgvmAHLM36OmaiMasQhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 15:21 -0700, Linus Torvalds wrote:
> On Thu, Jul 5, 2012 at 3:00 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > Like this?
> 
> Looks fine to me.
> 
> Although I think it might be better to stay closer to what we used to
> do, and just 'or' in the action flags rather than make it some
> conditional. And then at the end, do
> 
>    if (!(flags & __IRQF_TIMER))
>       add_interrupt_randomness(irq)

On systems with a timer interrupt and a sched_clock() that's
asynchronous to it, this actually loses a great source of entropy for
headless systems. Also: extra branch in fast path.

It's better to mix and not credit than to not mix at all. Instead just
check the fast count against HZ before the credit.

-- 
Mathematics is the supreme nostalgia of our time.


