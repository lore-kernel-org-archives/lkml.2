Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab2EIOr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:47:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56702 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753835Ab2EIOr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:47:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+uchFZiy6uZo4FYUtbWYXvoRJ2DcdEJjj8V1slTv
	z0PCXBmEPUAuHH
Message-ID: <1336574836.16079.17.camel@marge.simpson.net>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 09 May 2012 16:47:16 +0200
In-Reply-To: <alpine.DEB.2.00.1205090915430.8171@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
	 <1335830115-14335-8-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1205071053070.1060@router.home>
	 <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
	 <1336488626.16236.41.camel@twins>
	 <alpine.DEB.2.00.1205081016370.27713@router.home>
	 <1336490832.8226.5.camel@twins>
	 <alpine.DEB.2.00.1205081035550.27713@router.home>
	 <1336492081.8226.13.camel@twins>
	 <alpine.DEB.2.00.1205081054310.27713@router.home>
	 <1336493768.8226.29.camel@twins>
	 <1336506601.7400.21.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1205081541010.1391@router.home>
	 <1336537289.7365.62.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1205090915430.8171@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 09:22 -0500, Christoph Lameter wrote: 
> On Wed, 9 May 2012, Mike Galbraith wrote:

> > > isolcpus are not part of load balancer domains.
> >
> > Yup, so if you have an application with an RT component, somewhat
> > sensitive, needs isolation from rest of a big box, but app also has
> > SCHED_OTHER components.  isolcpus is a pain, everything has to be static
> > and nailed to the floor.  Load just works when plugged into a cpuset.
> 
> Well you have low latency requirements. If you code for lowest latency
> then you have to consider cache sizes, cache sharing etc etc. This means
> you will have to nail down everything anyways. Cpusets would just be
> another thing that one has to worry about.
> 
> The loads definitely wont work right if just "plugged into a cpuset".

You're talking about serious RT/HPC.  I'm talking about apps/loads with
modest requirements, like "Please keep that evil nVidia (this that the
other) thing the _hell_ away from me, I cannot deal with it's futzing
around in the kernel for a _full second_ at a time".

-Mike

