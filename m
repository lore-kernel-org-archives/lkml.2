Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2EIPGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:06:10 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:48897 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751133Ab2EIPGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:06:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4Gf79fkVM1kb9HTduNZawOqbBVwZWheej4J_VupnhJoCARM
 XxEjWStznP1YhoFrFZgm_Ni9xE7VKO.8znxGF.4ndmcTotSUeE9pBkOvsO63
 E1i.FfTFMR.HE1op.1DU_lJGK2rx4VjtK4JAv79bdbGF0JT8Gx0O9V5FthVw
 iSgocks7KOA8eOF1en3.NInqoTNI_ogQRmFWqolviOA3hxnNg7ME6M9wtcJu
 qqA0VtFTV7TmndzHvs1Mpz6K6nZ21oP924BCpU6Nfg31hCj3iFDCXTBh5yRb
 giFjrRZBEXuW0FOiApMaj28d6lToxqIm1pWD8bSbQhYvZ2MqUnFiJXhobSva
 FshqlJH.99SL0Yn6ZwHigW0g0lFHDdJMtWmCJ6rQDSB4lstO8bfwfVvz_e1r
 7
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 9 May 2012 10:05:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mike Galbraith <efault@gmx.de>
cc: Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
In-Reply-To: <1336574836.16079.17.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1205091001480.10177@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-8-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1205071053070.1060@router.home> <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
 <1336488626.16236.41.camel@twins> <alpine.DEB.2.00.1205081016370.27713@router.home> <1336490832.8226.5.camel@twins> <alpine.DEB.2.00.1205081035550.27713@router.home> <1336492081.8226.13.camel@twins> <alpine.DEB.2.00.1205081054310.27713@router.home>
 <1336493768.8226.29.camel@twins> <1336506601.7400.21.camel@marge.simpson.net> <alpine.DEB.2.00.1205081541010.1391@router.home> <1336537289.7365.62.camel@marge.simpson.net> <alpine.DEB.2.00.1205090915430.8171@router.home>
 <1336574836.16079.17.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Mike Galbraith wrote:

> On Wed, 2012-05-09 at 09:22 -0500, Christoph Lameter wrote:
> > On Wed, 9 May 2012, Mike Galbraith wrote:
>
> > > > isolcpus are not part of load balancer domains.
> > >
> > > Yup, so if you have an application with an RT component, somewhat
> > > sensitive, needs isolation from rest of a big box, but app also has
> > > SCHED_OTHER components.  isolcpus is a pain, everything has to be static
> > > and nailed to the floor.  Load just works when plugged into a cpuset.
> >
> > Well you have low latency requirements. If you code for lowest latency
> > then you have to consider cache sizes, cache sharing etc etc. This means
> > you will have to nail down everything anyways. Cpusets would just be
> > another thing that one has to worry about.
> >
> > The loads definitely wont work right if just "plugged into a cpuset".
>
> You're talking about serious RT/HPC.  I'm talking about apps/loads with
> modest requirements, like "Please keep that evil nVidia (this that the
> other) thing the _hell_ away from me, I cannot deal with it's futzing
> around in the kernel for a _full second_ at a time".

Well I hope you understand that I do not want to get another complexity
thrown in by having to deal with cpusets too in addition to the pinning,
caches, etc etc.

I do not get how a cpuset could be used by an application with load
balancing disabled. Seems to defeat the purpose of the cpuset (which IMHO
is to generate a custom load balancing domain after all). You would
have to manually pin the processes to processors of the cpuset anyways.

If you already have to pin then why would you want a cpuset on top of
that?


