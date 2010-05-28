Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab0E1MJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:09:13 -0400
Received: from ist.d-labs.de ([213.239.218.44]:59626 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab0E1MJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:09:11 -0400
Date: Fri, 28 May 2010 14:09:04 +0200
From: Florian Mickler <florian@mickler.org>
To: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528140904.0d0d4878@schatten.dmk.lab>
In-Reply-To: <AANLkTikumixQTaKvlyaxjZgfCZNZXFM9LySJ2YZ4OVZf@mail.gmail.com>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<alpine.LFD.2.00.1005271915540.3032@localhost.localdomain>
	<20100527173118.GE2468@srcf.ucam.org>
	<alpine.LFD.2.00.1005271959450.3032@localhost.localdomain>
	<20100528104415.1403541a@schatten.dmk.lab>
	<AANLkTikXtk-f41-z8gXfXLNLqgGVa0z4d-qgIvwljbR-@mail.gmail.com>
	<20100528122521.3698a62e@schatten.dmk.lab>
	<AANLkTikumixQTaKvlyaxjZgfCZNZXFM9LySJ2YZ4OVZf@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 04:35:34 -0700
Arve Hjønnevåg <arve@android.com> wrote:

> 2010/5/28 Florian Mickler <florian@mickler.org>:

> > It sounds like it could save some duplication of effort to integrate
> > suspend into the idle-framework. "Purpose-fulness" could be just
> > another measure of "idle".
> >
> 
> To me idle means that no threads are ready to run and no interrupts are pending.

I misused the term "idle".  I tried to express this by "quoting" it.

> 
> I don't think we can plug suspend in as a cpu idle state. 1. we want
> to suspend even the cpu is not idle. 2. starting suspend will cause
> the cpu to not be idle.
> 

yeah. it would have to move out of the cpu-specific context. it would
be a more general "system-state" thing.

if the properties of the state's are well expressed, it does not matter
that starting suspend will cause the cpu to not be idle, because our
target-state(suspend) has better properties than any other state.

(or maybe there needs to be a "state-transition-in-flight" flag.)

if we take the "approximated duration of staying in that state" into
account, we could provoke the pm-framework to always suspend if no
constraint(i.e. blocker) is there.

But really. I think I can't implement something like that.
Also I really have _no_ idea how much work this would be.

_And_ I am not really shure if this is a better approach than the
current solution.

Just an idea. 

Cheers,
Flo



