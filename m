Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab1FHUyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:54:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:60550 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab1FHUy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:54:29 -0400
Date: Wed, 8 Jun 2011 22:54:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Arne Jansen <lists@die-jansens.de>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, npiggin@kernel.dk, akpm@linux-foundation.org,
        frank.rowand@am.sony.com, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
In-Reply-To: <1307565125.2497.1003.camel@laptop>
Message-ID: <alpine.LFD.2.02.1106082252300.11814@ionos>
References: <20110606155236.GA7374@elte.hu>  <1307376039.2322.164.camel@twins> <20110606160810.GA16636@elte.hu>  <1307376771.2322.168.camel@twins> <20110606161749.GA22157@elte.hu>  <4DED0292.1040605@die-jansens.de> <4DED0423.4050904@die-jansens.de> 
 <20110606170725.GD2391@elte.hu> <1307380311.2322.223.camel@twins>  <1307548218.3941.6.camel@twins> <20110608191758.GA12457@elte.hu>  <BANLkTim8LY0ekPQNZasUbinKcvS78y_umw@mail.gmail.com> <1307565125.2497.1003.camel@laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Peter Zijlstra wrote:

> On Wed, 2011-06-08 at 12:27 -0700, Linus Torvalds wrote:
> > Make some kind of
> > 
> >   void atomic_down();
> >   int atomic_down_trylock();
> >   void atomic_up(); 
> 
> atomic_down() is a tad iffy, it would have to wait for an actual
> semaphore owner, which might sleep etc.. So I skipped it.
> 
> The other two are implemented here, and assume IRQs are disabled, we
> could add _irq and _irqsave versions of both, but since there are no
> users I avoided the effort.
> 
> ---
>  include/linux/semaphore.h |    3 +++
>  kernel/semaphore.c        |   36 +++++++++++++++++++++++++++++++++++-

Can we please confine this to kernel/printk.c ?

I can see the creative abuse of this already.

Thanks,

	tglx
