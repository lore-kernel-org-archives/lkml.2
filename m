Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0LMLZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:25:05 -0500
Received: from www.tglx.de ([62.245.132.106]:44562 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab0LMLZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:25:03 -0500
Date: Mon, 13 Dec 2010 12:24:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Simon Kirby <sim@hostway.ca>, linux-kernel@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [2.6.37-rc5] Timer or ICE1724 issues, HZ=250, NO_HZ=y
In-Reply-To: <20101213111900.GA2310@gentoo.trippels.de>
Message-ID: <alpine.LFD.2.00.1012131222420.2653@localhost6.localdomain6>
References: <20101213105440.GA12768@hostway.ca> <20101213111900.GA2310@gentoo.trippels.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Markus Trippelsdorf wrote:
> On 2010.12.13 at 02:54 -0800, Simon Kirby wrote:
> > With Linus git HEAD just compiled earlier today, I noticed a weird issue
> > just now while in the middle of some coding.  I think this may have
> > happened before (maybe in 2.6.36), but not as obvious as this time.
> > 
> > The music that was playing stopped, and the key I had just pressed did
> > not show up in rxvt.  I figured the machine had hung, but I hit another
> > key and the music played again for another second and my _previous_
> > keystroke output appeared.
> > 
> > Looking at /proc/interrupts, "timer" had completely stopped.  "perf top"
> > showed "snd_pcm_hwsync" was at the top of the profile with about 80%
> > usage.  Spinning in "snd_pcm_stream_lock_irq" from other CPUs, probably..
> > 
> > dmesg showed:
> > 
> > [13995.498393] Clocksource tsc unstable (delta = -8589909196 ns)
> > [13995.511452] Switching to clocksource hpet
> > [14039.525074] NOHZ: local_softirq_pending 100
> > [14039.882183] hrtimer: interrupt took 30800 ns
> > [14134.540724] NOHZ: local_softirq_pending 100
> 
> Welcome to the club. This is a known problem on newer AMD systems see:
> http://thread.gmane.org/gmane.linux.kernel/1054283
> and the following patch:
> http://thread.gmane.org/gmane.linux.kernel/1069458
> 
> But the real problem is that no patch found its way to Linus yet and
> 2.6.37 will be released in a few days. 
> 
> I think Thomas' solution (with a hardcoded hpet_min_tick):
>      return res < 128 ? -ETIME : 0;
> is the only sane option left this late in the series.

Yeah. I push that out to Linus. At some point we might hopefully get
some reliable information from the HW folks.

Thanks,

	tglx
