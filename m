Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab0EZRJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:09:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab0EZRJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:09:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Date: Wed, 26 May 2010 19:09:02 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00202-gac5d593; KDE/4.4.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <alpine.LFD.2.00.1005252129441.2948@localhost.localdomain> <4BFD4AC9.6080602@tilera.com>
In-Reply-To: <4BFD4AC9.6080602@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005261909.03315.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+VxQBVJN+Y1sdacriQXTbFdP+hvEclBgXNeHm
 XytuvIIH7YRV+9Dkg75vaaFVC4mtqCz9wVsW/ncuR3hJmVQYrk
 VBmlC6j0PSY2O154WTqVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010 18:22:33 Chris Metcalf wrote:
> On 5/25/2010 4:12 PM, Thomas Gleixner wrote:
> > +unsigned long long sched_clock(void)
> > +{
> > +     u64 cycles;
> > +     u32 cyc_hi, cyc_lo;
> > +
> > +     if (unlikely(cyc2ns_mult == 0))
> > +             setup_clock();
> >
> >   Please initialize stuff before it is called the first time and not
> >   at some arbitrary point conditionally in a hotpath.
> >   
> 
> Looking more closely at this, the reason for this lazy initialization
> was that sched_clock() can be called from lockdep_init(), which runs way
> before any tasteful architecture-specific initialization can happen. 
> Perhaps the correct model is that during the early stages of boot, we
> are happy to shift by zero, multiply by zero, and claim the time is zero :-)

Yes, that is what other architectures do. The time remains zero during
early boot. setup_arch is probably a good place to start the clock.

	Arnd
