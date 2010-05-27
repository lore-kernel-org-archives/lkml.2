Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0E0RZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:25:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0E0RZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:25:41 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527192135.6c6543b3@schatten.dmk.lab>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:25:27 +0200
Message-ID: <1274981127.27810.5597.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 19:21 +0200, Florian Mickler wrote:
> On Thu, 27 May 2010 18:45:25 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The whole notion of treating suspend to RAM any different than a plain
> > idle C-State is wrong. It's not different at all. You just use a
> > different mechanism which has longer takedown and wakeup latencies and
> > requires to shut down stuff and setup extra wakeup sources.
> > 
> > And there is the whole problem. Switching from normal event delivery
> > to those special wakeup sources. That needs to be engineered in any
> > case carefuly and it does not matter whether you add suspend blockers
> > or not.
> 
> Ok, I just don't know the answer: How is it just another idle state if
> the userspace gets frozen? Doesn't that bork the whole transition and
> you need a userspace<->kernel synchronisation point to not loose events?

There is no userspace to freeze when the runqueues are empty.

And as explained, you won't loose events if all the devices do a proper
state transition. To quote:

On Thu, 2010-05-27 at 18:45 +0200, Thomas Gleixner wrote:
> If the interrupt happens _BEFORE_ we switch over to the quiescent
> state, then we need to backout. If it happens after the switch then it
> goes into the nirwana if the suspend wakeup has not been set up
> correctly. If we have it setup correctly then we go into suspend just
> to come back immediately. There is nothing you can do about that with
> suspend blockers.
> 

