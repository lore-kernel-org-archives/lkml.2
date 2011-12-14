Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1LNJjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:39:08 -0500
Received: from [205.233.59.134] ([205.233.59.134]:50409 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1LNJjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:39:05 -0500
Message-ID: <1323855488.28489.16.camel@twins>
Subject: Re: printk() vs tty_io
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 Dec 2011 10:38:08 +0100
In-Reply-To: <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
References: <1323804803.9082.40.camel@twins>
	 <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 15:52 -0800, Linus Torvalds wrote:
> On Tue, Dec 13, 2011 at 11:33 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > I've been poking at reducing the constraints on printk(), like make it
> > work under rq->lock etc..
> 
> You aren't supposed register a console that wakes things up. But the
> only console that honors that afaik is the traditional vt console.
> *Maybe* the network console, I didn't check.
> 
> I *assume* you only get this lockdep warning if you have a serial console?

I only ever use serial, I'll try and have a go at reproducing any of
this on a machine that actually has a screen attached.

Anyway, would it make any sense to start enforcing this 'rule'? Can we
reasonably make the serial stuff not wake things? Let alone the
fbdev/ksm consoles that seem popular these days.

Thing is, if everybody and their dog are using ksm, and we cannot make
ksm console wake-free, there's a very limited point to my endeavor to
make printk() work under rq->lock etc..
