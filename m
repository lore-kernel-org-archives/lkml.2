Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0FAFgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:36:03 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44789 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab0FAFgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:36:00 -0400
Date: Tue, 1 Jun 2010 07:35:48 +0200
From: Florian Mickler <florian@mickler.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100601073548.5ed65352@schatten.dmk.lab>
In-Reply-To: <20100601122012.1edeaf48@notabene.brown>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<201006010005.19554.rjw@sisk.pl>
	<20100601090023.788cabf4@notabene.brown>
	<201006010232.20263.rjw@sisk.pl>
	<20100601113309.609349fd@notabene.brown>
	<alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
	<20100601122012.1edeaf48@notabene.brown>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 12:20:12 +1000
Neil Brown <neilb@suse.de> wrote:

> On Tue, 1 Jun 2010 03:49:37 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:

> > If "suspend" is another deep idle state and the hardware is sane,
> > there is no race at all - assumed that the driver/platform developer
> > got it right. It's not rocket science to transition from "normal" irq
> > delivery to wakeup based delivery raceless (except for PC style x86
> > hardware of today)

> > If "suspend" is the thing we are used to via /sys/power/state then the
> > race will persist forever except for the suspend blocker workaround,
> > which we can express in QoS terms as well w/o adding another suspend
> > related user space API.

Can you explain the difference between the /sys/power/state thing? Is
it the reprogramming of wake-sources as mentioned by Raffael?

In an idle based suspend I assume there would be no new wake-sources
on suspending.

> I'm not interested in adding another user-space API if it can possibly be
> avoided, and I think it can.  But that is a later step in the process.
> 
> I think you have acknowledged that there is a race with suspend - thanks.
> Next step was "can it be closed".
> You seem to suggest that it can, but you describe it as a "work around"
> rather than a "bug fix"...

Well as far as I get it, the workaround is to not suspend in sitations
where a race is likely to occur. (I.e. block suspend)

> 
> Do you agree that the race is a "bug", and therefore it is appropriate to
> "fix" it assuming an acceptable fix can be found (which I think it can)?
> 
> If you agree that it is appropriate for try to fix this bug, then the next
> step would be to get the Android devs to agree that a fix could - in
> principle - address the need for which they created suspend-blockers.
> Arve: can you confirm that?
> 
> Then, with a clear and agreed goal, we can look at possible fixes.
> 
> Thanks,
> NeilBrown
> 
> > 
> > Thanks,
> > 
> > 	tglx

cheers,
Flo
