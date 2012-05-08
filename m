Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2EHOvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:51:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51419 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2EHOvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:51:12 -0400
Message-ID: <1336488626.16236.41.camel@twins>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
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
Date: Tue, 08 May 2012 16:50:26 +0200
In-Reply-To: <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
	 <1335830115-14335-8-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1205071053070.1060@router.home>
	 <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 16:20 +0200, Frederic Weisbecker wrote:
> 2012/5/7 Christoph Lameter <cl@linux.com>:
> > On Tue, 1 May 2012, Frederic Weisbecker wrote:
> >
> >> Prepare the interface to implement the nohz cpuset flag.
> >> This flag, once set, will tell the system to try to
> >> shutdown the periodic timer tick when possible.
> >>
> >> We use here a per cpu refcounter. As long as a CPU
> >> is contained into at least one cpuset that has the
> >> nohz flag set, it is part of the set of CPUs that
> >> run into adaptive nohz mode.
> >
> > As I have said before: It would be much simpler if one could specify the
> > set of nohz cpus independently of cpusets. Having a flag f.e. as a file in
> >
> >        /sys/devices/system/cpu/cpuX/nohz
> 
> I don't know if it would be simpler. It's just a different interface
> to set a per-CPU property.
> Cpusets of sysfs, I don't mind either way.
> 
> What is the usual policy on where to put which kind of CPU property?

There's no such policy, but I don't get why Christoph objects to
cpusets, its the option I would prefer. You're going to use cpusets
anyway to partition your system, might as well also use it to mark a
whole partition/set as nohz.
