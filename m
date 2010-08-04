Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804Ab0HDUwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:52:16 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37361 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934580Ab0HDUwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:52:06 -0400
Date: Wed, 4 Aug 2010 13:51:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804205159.GH24163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100801054816.GI2470@linux.vnet.ibm.com>
 <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
 <20100801154708.19817b75@infradead.org>
 <20100802011006.GS2470@linux.vnet.ibm.com>
 <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
 <20100803183447.0275c134@infradead.org>
 <20100804163216.GB24163@linux.vnet.ibm.com>
 <20100804163509.GA31523@srcf.ucam.org>
 <20100804204208.GA21452@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804204208.GA21452@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 10:42:08PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > If this doesn't work for the Android folks for whatever reason, another
> > > approach would be to do the freeze in user code, which could track
> > > whether any user-level resources (pthread mutexes, SysV semas, whatever)
> > > where held, and do the freeze on a thread-by-thread basis within each
> > > "victim" application as the threads reach safe points.
> > 
> > The main problem I see with the cgroups solution is that it doesn't seem 
> > to do anything to handle avoiding loss of wakeup events.
> 
> In different message, Arve said they are actually using low-power idle
> to emulate suspend on Android.

Hello, Pavel,

Could you please point me at this message?

							Thanx, Paul

> This came like a bit of a shock to me ("why do they make it so complex
> then"), but... it also means that as soon as you are able to stop
> "unwanted" processing, you can just leave normal cpuidle mechanisms to
> deal with the rest...
> 
> (Of course, you'll also have to fix kernel timers not to beat
> unneccessarily often; still that's better solution that just stoping
> them all and then sprinkling wakelocks all over the kernel to deal
> with obvious bugs it introduces...)
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
