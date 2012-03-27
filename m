Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2C0QIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:08:12 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:45948 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003Ab2C0QIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:08:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6TBdAUIVM1kGlUpZnNnJuvJOuRt2GgiEddsQg4CjA3RuDCy
 Pm48uFLHYu_TQ13o1eb2.riOO.d45YqmJg2Fux9sVwDmtRvlC5p4MG6c_ZTF
 Z8LoaTFThlypp_10KMj2Jrymx2kmiMTl6kE4SvXAWuVOIrWWZ6ui.j_JePzx
 vO4.K3eUVo_iAME2Fjhr8LfxEmC3KpX6FVE4gbLO6CBxKM_3.B1aeaBxNrNg
 Nl7A8IUX8FuBGNo1JGn7l0id6_evq.UkV8qn6QH6Btmj_vBB3tmC1GHnvqRA
 clkVew.6zhQA8se7O4aUgT4UJlhNKuPZCINj20TKkE9priKK6Bgp7PFju5.Q
 inCBWyHCQV5DMxCjZk07AMRYwuGEv7s5fWLokScNzDSiW26DJYKaNOAPU_sl
 Gb5cp8ytp7A_jkJXOwvUQkAKCLkDY7kWoJ8yvHb.wh9zHd.STMP7wHN3WwM6
 jfofmoITsNd8vhg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Mar 2012 11:08:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 08/32] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
In-Reply-To: <20120327105034.GA13196@somewhere>
Message-ID: <alpine.DEB.2.00.1203271106130.1170@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-10-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1203210950500.20482@router.home> <20120327105034.GA13196@somewhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Frederic Weisbecker wrote:

> > Any way to manually specify which cpu? We f.e. always "sacrifice" cpu 0
> > for OS activities. We would like to have all Os processing things
> > restricted to cpu 0 so that the rest of the processors do not experience
> > the OS noise.
>
> Somebody tries to do this: https://lkml.org/lkml/2011/11/8/346
>
> But in the case of nohz cpusets there is a problem to solve:
>
> What if every CPUs are tickless (idle or busy), who must take
> the timekeeping duty? Should we pick one of the busy CPUs? Or
> keep one CPU with the tick even if it's idle? How do we choose
> this CPU?

Then its the users fault because he specified the processor to use. There
is no picking if its manually assigned.

> May be we need to define another flag on cpusets to assign the
> timekeeping duty to any CPU on a flagged set. This way we can
> force that duty to the CPU(s) we want.

I wish you would disentangle the nohz work from the cpusets. Cpusets is
aged and being replaced by cgroups. And the cgroup work is something that
is not suitable for many loads given the VM overhead added.

