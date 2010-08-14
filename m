Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab0HNHjC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 03:39:02 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52452 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932895Ab0HNHjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 03:39:00 -0400
Date: Sat, 14 Aug 2010 09:38:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100814073843.GA27430@elf.ucw.cz>
References: <20100809112453.77210acc@lxorguk.ukuu.org.uk>
 <20100809181638.GI3026@linux.vnet.ibm.com>
 <AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com>
 <20100811222854.GJ2516@linux.vnet.ibm.com>
 <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
 <20100812010612.GL2516@linux.vnet.ibm.com>
 <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
 <20100812034435.GA7403@linux.vnet.ibm.com>
 <20100813115751.3bbbafbd@lxorguk.ukuu.org.uk>
 <20100813152912.GE2511@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813152912.GE2511@linux.vnet.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Think in terms of an ARM laptop. What good is opportunistic suspend if
> > > > it's not going to help when the laptop is being used?
> > > 
> > > For when the laptop is not being used, presumably.
> > 
> > Or in time between keystrokes for most of the platform (backlight
> > excepted). The Intel MID x86 devices are at the point that suspend/resume
> > time on x86 is being hurt by the kernel rewriting smp alternatives as we
> > go from 2 processors live to 1 and back.
> 
> Given that you are talking about going from 2 processors to 1 and back,
> I would guess that you are not actually talking about suspend/resume,
> which is a system-wide thing rather than a CPU-by-CPU thing.  I am not
> sure whether you are using CPU hotplug or invoking SMP alternatives once
> all but one CPU is idle.

When entering system suspend, we disable non-boot-CPUs to simplify
locking. We reenable them when going out of suspend.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
