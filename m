Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab1LBWmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:42:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:49523 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab1LBWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:42:43 -0500
Date: Fri, 2 Dec 2011 23:42:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
In-Reply-To: <20111202201452.GF2164@sgi.com>
Message-ID: <alpine.LFD.2.02.1112022338380.2735@ionos>
References: <20111108191149.GA7236@sgi.com> <20111122160802.e99d6218.akpm@linux-foundation.org> <20111130152959.GA19205@sgi.com> <20111130161131.31cdccff.akpm@linux-foundation.org> <20111130161610.69c516f7.akpm@linux-foundation.org> <20111201020727.GB30097@sgi.com>
 <20111130181318.38f4659d.akpm@linux-foundation.org> <20111201163740.GA11693@sgi.com> <20111201145623.d2bf252e.akpm@linux-foundation.org> <20111202201452.GF2164@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Dimitri Sivanich wrote:
> On Thu, Dec 01, 2011 at 02:56:23PM -0800, Andrew Morton wrote:
> Well, we do have to take the write_seqlock() in tick_periodic, so there's
> no danger of do_timer running exactly concurrently.
> 
> But yes, we may end up with 2 jiffies ticks occurring close together
> (when 5 runs do_timer while 4 waits for the seqlock), or we might end up
> missing a jiffies update for almost a full tick (when it changes from 5
> to 4 immediately after 4 has done the 'tick_do_timer_cpu == cpu' check).
> 
> So at that time, we could be off +- almost a tick.  The question is, how
> critical is that?  When you down a cpu, the same sort of thing could 
> happen via tick_handover_do_timer(), which itself does nothing more than
> change tick_do_timer_cpu.

It's uncritical as long as you are not using clocksource=jiffies. With
all other clocksources you just miss a jiffies update, which does not
affect timekeeping at all. It just might expire your network timeout a
jiffie earlier or later. So there is no damage to expect.

Thanks,

	tglx

