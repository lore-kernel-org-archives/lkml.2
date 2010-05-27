Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab0E0Rmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:42:49 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44594 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799Ab0E0Rmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:42:47 -0400
Date: Thu, 27 May 2010 19:42:41 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527194241.52caaf37@schatten.dmk.lab>
In-Reply-To: <1274981127.27810.5597.camel@twins>
References: <20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
	<alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
	<20100527192135.6c6543b3@schatten.dmk.lab>
	<1274981127.27810.5597.camel@twins>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 19:25:27 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-05-27 at 19:21 +0200, Florian Mickler wrote:
> > On Thu, 27 May 2010 18:45:25 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > The whole notion of treating suspend to RAM any different than a plain
> > > idle C-State is wrong. It's not different at all. You just use a
> > > different mechanism which has longer takedown and wakeup latencies and
> > > requires to shut down stuff and setup extra wakeup sources.
> > > 
> > > And there is the whole problem. Switching from normal event delivery
> > > to those special wakeup sources. That needs to be engineered in any
> > > case carefuly and it does not matter whether you add suspend blockers
> > > or not.
> > 
> > Ok, I just don't know the answer: How is it just another idle state if
> > the userspace gets frozen? Doesn't that bork the whole transition and
> > you need a userspace<->kernel synchronisation point to not loose events?
> 
> There is no userspace to freeze when the runqueues are empty.

If in the imaginery situation where userspace can aquire certain
wakeup-constraints and loose certain wakeup-constraints, then it could
be that the system enters suspend without empty runqueues. 

> And as explained, you won't loose events if all the devices do a proper
> state transition. To quote:

I believe the problem beeing userspace frozen at an unopportune time.
So the wakeup event is processed (kernel-side) but userspace didn't
have time to reacquire the correct wakeup-constraint to process the
event.

I.e. the wakeup will be effectivly ignored.


Cheers,
Flo
