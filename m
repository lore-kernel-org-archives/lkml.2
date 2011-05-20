Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935137Ab1ETQWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:22:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:41739 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934587Ab1ETQWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:22:37 -0400
Date: Fri, 20 May 2011 18:22:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: LKML <linux-kernel@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan>
Message-ID: <alpine.LFD.2.02.1105201819310.3078@ionos>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan> <alpine.LFD.2.02.1105201445300.3078@ionos> <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan> <alpine.LFD.2.02.1105201528500.3078@ionos> <alpine.DEB.2.02.1105200945300.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201712501.3078@ionos> <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, Justin Piszcz wrote:
> On Fri, 20 May 2011, Thomas Gleixner wrote:
> 
> > On Fri, 20 May 2011, Justin Piszcz wrote:
> > > On Fri, 20 May 2011, Thomas Gleixner wrote:
> > > > Does it crash right away or just when doing something particular?
> > > It crashed at 2100, this is when I run a few I/O intensive processes:
> > > - backup (dump ext4 filesystem -> to a separate raid device)
> > > - backup (dump ext4 on remote host -> to separate raid device)
> > > - backup (dump xfs on remote host -> to separate raid device)
> > > 
> > > This looks like it is what caused it to crash.
> > 
> > That narrows it down somewhat, but does not give us a clue at all :(
> > 
> > > > Is the box fully dead after the crash ?
> > > The host was online and I went away for awhile, when I came back the
> > > system
> > > had rebooted on its own (as I lost all of my X windows/etc).
> > 
> > Hmm. Did you have panic_timeout set ?
> 
> Hi,
> 
> No, I do not use panic_timeout or any type of watchdog that would reboot
> the system upon a lockup/crash.

Yuck, that means it ran into a triple fault. Nasty. I have no idea how
to debug that at the moment and I was not able to reproduce on one of
my test systems. Maybe I need to try harder.

Thanks,

	tglx




