Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0DAInU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:43:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40138 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0DAInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:43:13 -0400
Date: Thu, 1 Apr 2010 10:43:11 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, rsc@pengutronix.de
Subject: Re: Issues with Patch: "sched: Improve latencies and throughput"
Message-ID: <20100401084311.GL10342@pengutronix.de>
References: <20100331223106.GJ10342@pengutronix.de> <1270100986.6707.156.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270100986.6707.156.camel@marge.simson.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:25:29 up 11 days, 21:15, 30 users,  load average: 0.95, 0.77,
	0.95
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 07:49:46AM +0200, Mike Galbraith wrote:
> On Thu, 2010-04-01 at 00:31 +0200, Michael Grzeschik wrote:
> > We are using an arm mx31 embedded cpu with the v2.6.34 Kernelrelease and
> > realized some issues with the scheduling behaviour the patch "sched:
> > Improve latencies and throughput" [1] by Mike Galbraith introduced to
> > the kernel.
> > 
> > When we used the alsa utility aplay to pipe some audio through an
> > usbaudio device and put some scheduling overhead on the device, the
> > amount of underruns, due to the not fast enough refilled ring buffer,
> > was noticable increased with that patch [1] applied. Until we reverse
> > applied the patch the amount of underruns was appreciable lower.
> 
> Testcase?

What we did was:

# Copy some audiofile to /dev/shm
$ cp audiofile.wav /dev/shm

# Play that file with aplay in background
$ aplay /dev/shm/auduifile.wav &

# Put some scheduling load on the system
$ hackbench 6

We did use this on an MX31 from Freescale running with about 500 MHz and
the generic usbaudio driver to play the audio throgh an C-Media USB
audiodongle.

Expected results with that patch:

underrun!!! (at least 323.946 ms long) < -- aplay
underrun!!! (at least 59.477 ms long)  < --     "
underrun!!! (at least 194.873 ms long) < --     "
Time: 7.048                            < -- hackbench
Time: 6.841                            < --     "
underrun!!! (at least 115.456 ms long) < -- aplay
underrun!!! (at least 37.849 ms long)  < --     "
underrun!!! (at least 588.637 ms long) < --     "
Time: 7.23                             < -- hackbench

results without the patch:

Time: 3.728                            < -- hackbench
underrun!!! (at least 58.557 ms long)  < -- aplay
Time: 3.771                            < -- hackbench
underrun!!! (at least 97.538 ms long)  < -- aplay
Time: 3.732                            < -- hackbench
Time: 3.630                            < --  ....
Time: 3.636
Time: 3.643

Thanks,
mgr

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
