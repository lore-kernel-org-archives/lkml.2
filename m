Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1ACOVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:21:30 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49190 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932077Ab1ACOV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:21:28 -0500
Date: Mon, 3 Jan 2011 15:17:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <hgu1972@gmail.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
Message-ID: <20110103141749.GB1536@ucw.cz>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
 <1292596194.2266.283.camel@twins>
 <1292596369.2266.286.camel@twins>
 <AANLkTinGkf3a4_sw32b4UqAmpUU+i6fDmDUT8tXdw14D@mail.gmail.com>
 <1292599007.2266.290.camel@twins>
 <alpine.LFD.2.00.1012171630330.12146@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012171630330.12146@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Yes, I and you have already suggested the safe way to not lower it below
> > > the total dl bandwidth. But for softer use cases it might be possible to
> > > e.g. exclude threads with longer periods than cpufreq change periods in the
> > > minimum frequency.
> > 
> > I was more hinting at the fact that CPUfreq is at best a controversial
> > approach to power savings. I much prefer the whole race-to-idle
> > approach, its much simpler.
> 
> There's that and I have yet to see a proof that running code with
> lower frequency and not going idle saves more power than running full
> speed and going into low power states for longer time.

That depends on cpu. Look at early athlon64s that could not even run
at full speed at battery power, and where cpu sleep states were not
saving much power. Race-to-idle does not work there. It works on
recent x86 cpus.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
