Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab2EIOW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:22:29 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:25295 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757863Ab2EIOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:22:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7Ms8CL8VM1mivEnTZPfaX5cKiLKZVhkTuiA_j2fV2lEvvKT
 Z_ate.lBdifk0GKHwwZlv73iMeksS2DpKV_0l2yaEAH3wlEtF1sKN19byfGC
 tM09msE4iMvV0cGw0ThjHTgicbM9FgjayTCCLYMG1.6Do7hGgv_WuhxIb1aD
 F46Hwl0ZQoqegLrCkBUJ91eH_XDYP4me26H5wk0sA8hBmLbiGOyeQR8Or3jc
 xTh94dgK8JwIYxybDywjVP0gK1APxYS3EEwWM_Xgwcdcfz9CcaAfknZ1RxIh
 K1EPTJqn4jYU4VUWbkcI6iMFKffch83wajENpT1Og9aOMKWS2IXa7yafuj59
 sH0eJOFyavIsGq8fV7LvssDu0hMWpGctYQJVsL2d5y4LxX4kJY51po3ZQg0h
 T
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 9 May 2012 09:22:21 -0500 (CDT)
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
In-Reply-To: <1336537289.7365.62.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1205090915430.8171@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-8-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1205071053070.1060@router.home> <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
 <1336488626.16236.41.camel@twins> <alpine.DEB.2.00.1205081016370.27713@router.home> <1336490832.8226.5.camel@twins> <alpine.DEB.2.00.1205081035550.27713@router.home> <1336492081.8226.13.camel@twins> <alpine.DEB.2.00.1205081054310.27713@router.home>
 <1336493768.8226.29.camel@twins> <1336506601.7400.21.camel@marge.simpson.net> <alpine.DEB.2.00.1205081541010.1391@router.home> <1336537289.7365.62.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Mike Galbraith wrote:

> > Its not a good match for this. You would want a per cpu attribute for
> > nohz.
>
> Or per cpuset, which can be the same thing as per cpu if you want.

But now we start to manage per cpu characteristics with cpusets whereas
before cpusets was used mainly to manage groups of processors assigned to
applications! This means there will be a requirement to use cpusets in
environments that have not used them before.

> > isolcpus are not part of load balancer domains.
>
> Yup, so if you have an application with an RT component, somewhat
> sensitive, needs isolation from rest of a big box, but app also has
> SCHED_OTHER components.  isolcpus is a pain, everything has to be static
> and nailed to the floor.  Load just works when plugged into a cpuset.

Well you have low latency requirements. If you code for lowest latency
then you have to consider cache sizes, cache sharing etc etc. This means
you will have to nail down everything anyways. Cpusets would just be
another thing that one has to worry about.

The loads definitely wont work right if just "plugged into a cpuset".
