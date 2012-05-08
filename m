Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab2EHP52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:57:28 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:39478 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754876Ab2EHP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:57:27 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jKQaaZUVM1kWDFMlulShOFOoSCpCeA3xY3mqk_.ugkdez.p
 05OrjOW63ONtbATn0MK0qHYJPeU3NMy5znjk1Es7fphSZ6sTfp9vADfAqZPJ
 PXd4Vq6yZFnCLMlDlmylaczQEJewC.Yhm7oDJLe3JLUM8tsSY.8nDJ4p.JuB
 1VQ0lfx_c0OmGckuF.IJa8AzaCazSm.DhicjATlOTyhcjE6q5skdGl76M54m
 _6zuSGrT0dRkhdimIOdJU6calKI3ABMtYXC8nVWAatwiD4Nmp_Xc.6MpOXvk
 2uvi9zzIsTQUDDKUR6McdiH6X4p9gVg63mS4_SeOcB38cyWntDSyP4oun8BN
 xNtDstmoNLSVtyhrXMjRw.Y9UXZDKGuZR3Fhh02LbYoBr5r2PDkwEemMJDMN
 b
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 10:57:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
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
In-Reply-To: <1336492081.8226.13.camel@twins>
Message-ID: <alpine.DEB.2.00.1205081054310.27713@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-8-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1205071053070.1060@router.home> <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
 <1336488626.16236.41.camel@twins> <alpine.DEB.2.00.1205081016370.27713@router.home> <1336490832.8226.5.camel@twins> <alpine.DEB.2.00.1205081035550.27713@router.home> <1336492081.8226.13.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Peter Zijlstra wrote:

> > For some reason this seems to work here. What is broken with isolcpus?
>
> It mostly still works I think, but iirc there were a few places that
> ignored the cpuisol mask.

Yes there is still superfluous stuff going on on isolated processors.

> But really the moment we get proper means of flushing cpu state
> (currently achievable by unplug-replug) isolcpu gets depricated and
> eventually removed.

Not sure what that means and how that is relevant. Scheduler?

> cpusets can do what isolcpu can and more (provided this flush thing).

cpusets is a pretty heavy handed thing and causes inefficiencies in the
allocators if compiled into the kernel because checks will have to be done
in hot allocation paths.

> > > Furthermore there is no other partitioning scheme, cpusets is it.
> >
> > One can partition the system anyway one wants by setting cpu affinities
> > and memory policies etc. No need for cpusets/cgroups.
>
> Not so, the load-balancer will still try to move the tasks and
> subsequently fail. Partitioning means it won't even try to move tasks
> across the partition boundary.

Ok so the scheduler is inefficient on this. Maybe that can be improved?

Setting affinities should not cause overhead in the scheduler.

> By proper partitioning you can split load balance domains (or completely
> disable the load-balancer by giving it a single cpu domain).

I thought that was the point of isolcpus?

