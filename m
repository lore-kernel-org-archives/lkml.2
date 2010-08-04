Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878Ab0HDVPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:15:52 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51284 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934820Ab0HDVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:15:45 -0400
Date: Wed, 4 Aug 2010 23:15:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804211513.GC21452@elf.ucw.cz>
References: <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
 <20100801154708.19817b75@infradead.org>
 <20100802011006.GS2470@linux.vnet.ibm.com>
 <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
 <20100803183447.0275c134@infradead.org>
 <20100804163216.GB24163@linux.vnet.ibm.com>
 <20100804163509.GA31523@srcf.ucam.org>
 <20100804204208.GA21452@elf.ucw.cz>
 <20100804205159.GH24163@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804205159.GH24163@linux.vnet.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > If this doesn't work for the Android folks for whatever reason, another
> > > > approach would be to do the freeze in user code, which could track
> > > > whether any user-level resources (pthread mutexes, SysV semas, whatever)
> > > > where held, and do the freeze on a thread-by-thread basis within each
> > > > "victim" application as the threads reach safe points.
> > > 
> > > The main problem I see with the cgroups solution is that it doesn't seem 
> > > to do anything to handle avoiding loss of wakeup events.
> > 
> > In different message, Arve said they are actually using low-power idle
> > to emulate suspend on Android.
> 
> Hello, Pavel,
> 
> Could you please point me at this message?

AFAICT, this tells us that idle and suspend is the same hardware state
on current Android hardware:
								Pavel

Message-ID: <AANLkTinjH0C0bSK=Y2wKASnbJFsR2BN303xBXkaHbmRC@mail.gmail.com>

Arve said:

If you just program the alarm you will wake up see that the monotonic
clock has not advanced and set the alarm another n seconds into the
future. Or are proposing that suspend should be changed to keep the
monotonic clock running? If you are, why? We can enter the same
hardware states from idle, and modifying suspend to wake up more often
would increase the average power consumption in suspend, not improve
it for idle. In other words, if suspend wakes up as often as idle, why
use suspend?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
