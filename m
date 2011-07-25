Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1GYHzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:55:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46256 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1GYHzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:55:09 -0400
Date: Mon, 25 Jul 2011 09:54:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
        x86 <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] syscall calling convention, stts/clts, and xstate latency
Message-ID: <20110725075422.GB32294@elte.hu>
References: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com>
 <20110724211526.GA6785@elte.hu>
 <4E2D1E57.1080404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2D1E57.1080404@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 07/25/2011 12:15 AM, Ingo Molnar wrote:
> >>  All of this makes me think that, at least on Sandy Bridge, lazy
> >>  xstate saving is a bad optimization -- if the cache is being nice,
> >>  save/restore is faster than twiddling the TS bit.  And the cost of
> >>  the trap when TS is set blows everything else away.
> >
> > Interesting. Mind cooking up a delazying patch and measure it on 
> > native as well? KVM generally makes exceptions more expensive, so 
> > the effect of lazy exceptions might be less on native.
> 
> While this is true in general, kvm will trap #NM only after a host 
> context switch or an exit to host userspace.  These are supposedly 
> rare so you won't see them a lot, especially in a benchmark 
> scenario with just one guest.
> 
> ("host context switch" includes switching to the idle thread when 
> the guest executes HLT, something I tried to optimize in the past 
> but it proved too difficult for the gain)

Yeah - but this was a fair thing to test before Andy embarks on 
something more ambitious on the native side.

Thanks,

	Ingo
