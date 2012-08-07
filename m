Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2HGS2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:28:34 -0400
Received: from relais.videotron.ca ([24.201.245.36]:48781 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab2HGS2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:28:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 07 Aug 2012 14:28:31 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
In-reply-to: <20120807173344.GD16877@mudshark.cambridge.arm.com>
Message-id: <alpine.LFD.2.02.1208071405590.5231@xanadu.home>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208071259270.5231@xanadu.home>
 <20120807173344.GD16877@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012, Will Deacon wrote:

> On Tue, Aug 07, 2012 at 06:14:36PM +0100, Nicolas Pitre wrote:
> > On Tue, 7 Aug 2012, Will Deacon wrote:
> > > The symptoms are that a bunch of hackbench tasks are left waiting on an
> > > unlocked mutex and therefore never get woken up to claim it. I think this
> > > boils down to the following sequence:
> > > 
> > > 
> > >         Task A        Task B        Task C        Lock value
> > > 0                                                     1
> > > 1       lock()                                        0
> > > 2                     lock()                          0
> > > 3                     spin(A)                         0
> > > 4       unlock()                                      1
> > > 5                                   lock()            0
> > > 6                     cmpxchg(1,0)                    0
> > > 7                     contended()                    -1
> > > 8       lock()                                        0
> > > 9       spin(C)                                       0
> > > 10                                  unlock()          1
> > > 11      cmpxchg(1,0)                                  0
> > > 12      unlock()                                      1
> > > 
> > > 
> > > At this point, the lock is unlocked, but Task B is in an uninterruptible
> > > sleep with nobody to wake it up.
> > 
> > I fail to see how the lock value would go from -1 to 0 on line 8.  How 
> > does that happen?
> 
> [...]

Forget that.  I assumed cmpxchg when it is just xchg.

(And, for that matter, I'm even the original author for some of that 
 code.: http://lkml.org/lkml/2005/12/26/83).

Back to thinking.


Nicolas
