Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0IHNwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:52:40 -0400
Received: from www.tglx.de ([62.245.132.106]:36542 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab0IHNwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:52:37 -0400
Date: Wed, 8 Sep 2010 15:52:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
cc: Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: slow nanosleep?
In-Reply-To: <OFA5A9E9D0.0B55FA15-ONC1257798.004A7BB3-C1257798.004B86F2@transmode.se>
Message-ID: <alpine.LFD.2.00.1009081551510.2477@localhost6.localdomain6>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>  <1283932600.2880.1.camel@edumazet-laptop>  <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se>  <1283934289.2880.12.camel@edumazet-laptop> 
 <OF2B75FA7C.7064BC41-ONC1257798.00318FDA-C1257798.00329AEF@transmode.se>  <alpine.LFD.2.00.1009081143200.2477@localhost6.localdomain6>  <OF82705D74.3C13AE80-ONC1257798.00427DAB-C1257798.0042F243@transmode.se>  <alpine.LFD.2.00.1009081442390.2477@localhost6.localdomain6>
 <1283950818.23762.20.camel@laptop> <OFA5A9E9D0.0B55FA15-ONC1257798.004A7BB3-C1257798.004B86F2@transmode.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, Joakim Tjernlund wrote:

> Peter Zijlstra <peterz@infradead.org> wrote on 2010/09/08 15:00:18:
> >
> > On Wed, 2010-09-08 at 14:43 +0200, Thomas Gleixner wrote:
> > > > However nanosleep with 1 ns and prctl(PR_SET_TIMERSLACK, 1) takes
> > > > about 8 us on x86(Intel(R) Core(TM)2 Duo CPU E8500  @ 3.16GHz)
> > > > and 20 us on my slower ppc board. Is that system call overhead
> > > > or possibly some error?
> > >
> > > That's overhead I fear. We go way up to enqueue/arm the timer until we
> > > figure out that the timeout already happened.
> >
> > Well, there's also the fact that his ppc board is simply dead slow,
> > using the freq ratio: 3166/266 you'd expect (at a similar ins/clock
> > ratio) the ppc to take 95us.
> >
> > So in fact the pcc taking 20us is actually quite good.
> 
> Actually, it takes 120 us. The 20 us was when I had Thomas
> timeout == 0 fast path patch applied(forgot to remove it).
> Without that patch it takes about 115 us. So it seems it takes
> 115-20=95 us to turn the timer wheel on my ppc.

You might fire up the tracer to look where it spends that time.

Thanks,

	tglx
