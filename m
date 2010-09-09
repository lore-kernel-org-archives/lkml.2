Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab0IIOmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:42:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37062 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755063Ab0IIOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:42:13 -0400
Date: Thu, 9 Sep 2010 16:02:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
Message-ID: <20100909160217.59f9c491@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1009091443250.2477@localhost6.localdomain6>
References: <cover.1283504065.git.richard.cochran@omicron.at>
	<alpine.LFD.2.00.1009091152300.2477@localhost6.localdomain6>
	<20100909122156.GA2823@riccoc20.at.omicron.at>
	<alpine.LFD.2.00.1009091443250.2477@localhost6.localdomain6>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1. character device (like hpet)
> > 2. posix clock api
> > 3. sysfs
> > 
> > Or possibly some combination of the three.
> 
> I fail to see the requirement for any of those. Either the hardware
> clock is suitable as a clocksource for general consumption, then it
> should just be used as a clock source. If it's not - e.g. because it's
> too slow to access - then it just should serve as a reference in the
> NTP style and steer the timekeeping into sync.

I think you are confusing clocks, time stamps and the system time.

System time is a single default reference source defined by POSIX in
terms of sort of UTC.

There are lots of other time sources which don't necessarily tally with
oen another and there are times you have to respect more than one of them
because you are not the master clock nor can you dictate synchronization
between the two pieces of infrastructure you span

Consider a large rock gig - your control systems for the speakers and PA
are tightly synchronized and delivering audio with very precise delays to
different amp/speaker combinations. At the same time if you are managing
effects and the like then the instrument timings for those will be coming
off another clock, which is also very precise and differently sourced.

So what we actually have is

- multiple input devices that report timestamps (the PC clock, GPS, PTP,
  time synchronized busses, synchronous ethernet, network provided reports
  etc)

- some of those inputs get turned into clocks with varying degrees of
  hardware and software processing which are consumed by various bits of
  software and drivers

- a subset of those clocks in some form are algmated into a generic
  system time. which provides a meaningful representation of general time
  to the majority of apps that simple can't care less

Apps and drivers need access to all three layers.

