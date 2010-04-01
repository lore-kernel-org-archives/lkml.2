Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab0DATf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:35:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:40438 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755154Ab0DATfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:35:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18LfaEKoq8LfbFmU2fySUGPBsvOAovtI3VkqrnFvt
	UduWPkASg5Eq3p
Subject: Re: Issues with Patch: "sched: Improve latencies and throughput"
From: Mike Galbraith <efault@gmx.de>
To: Michael Grzeschik <mgr@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, rsc@pengutronix.de
In-Reply-To: <20100401084311.GL10342@pengutronix.de>
References: <20100331223106.GJ10342@pengutronix.de>
	 <1270100986.6707.156.camel@marge.simson.net>
	 <20100401084311.GL10342@pengutronix.de>
Content-Type: text/plain
Date: Thu, 01 Apr 2010 21:35:50 +0200
Message-Id: <1270150550.6413.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 10:43 +0200, Michael Grzeschik wrote:
> On Thu, Apr 01, 2010 at 07:49:46AM +0200, Mike Galbraith wrote:
> > On Thu, 2010-04-01 at 00:31 +0200, Michael Grzeschik wrote:
> > > We are using an arm mx31 embedded cpu with the v2.6.34 Kernelrelease and
> > > realized some issues with the scheduling behaviour the patch "sched:
> > > Improve latencies and throughput" [1] by Mike Galbraith introduced to
> > > the kernel.
> > > 
> > > When we used the alsa utility aplay to pipe some audio through an
> > > usbaudio device and put some scheduling overhead on the device, the
> > > amount of underruns, due to the not fast enough refilled ring buffer,
> > > was noticable increased with that patch [1] applied. Until we reverse
> > > applied the patch the amount of underruns was appreciable lower.
> > 
> > Testcase?
> 
> What we did was:
> 
> # Copy some audiofile to /dev/shm
> $ cp audiofile.wav /dev/shm
> 
> # Play that file with aplay in background
> $ aplay /dev/shm/auduifile.wav &
> 
> # Put some scheduling load on the system
> $ hackbench 6
> 
> We did use this on an MX31 from Freescale running with about 500 MHz and
> the generic usbaudio driver to play the audio throgh an C-Media USB
> audiodongle.

Hm.  I don't _think_ you've demonstrated a clear problem yet.

Q: how much CPU is aplay routinely using on this platform?

	-Mike

