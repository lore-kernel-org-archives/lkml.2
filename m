Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab0E0RwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:52:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:56986 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331Ab0E0RwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:52:21 -0400
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
In-Reply-To: <20100527194241.52caaf37@schatten.dmk.lab>
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
	 <20100527194241.52caaf37@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:52:09 +0200
Message-ID: <1274982729.27810.5703.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 19:42 +0200, Florian Mickler wrote:

> If in the imaginery situation where userspace can aquire certain
> wakeup-constraints and loose certain wakeup-constraints, then it could
> be that the system enters suspend without empty runqueues. 

No. Wakeup constaints simply delay wakeups, not loose them.

If there's something runnable, we run it.

What could happen is that you try to program a timer every 5ms, but then
QoS won't let you and errors the timer_create() or something. But then
the app gets to deal with it.

> > And as explained, you won't loose events if all the devices do a proper
> > state transition. To quote:
> 
> I believe the problem beeing userspace frozen at an unopportune time.
> So the wakeup event is processed (kernel-side) but userspace didn't
> have time to reacquire the correct wakeup-constraint to process the
> event.
> 
> I.e. the wakeup will be effectivly ignored.

How so, event happens on hardware level, IRQ gets raised, CPU wakes up,
handler gets run, handler generates a task wakeup, runqueue isn't empty,
we run stuff.

I'm not quite sure how to loose something there.
