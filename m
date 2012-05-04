Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab2EDVes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:34:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60062 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab2EDVeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:34:46 -0400
Message-ID: <1336167265.6509.83.camel@twins>
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 04 May 2012 23:34:25 +0200
In-Reply-To: <20120504212758.GC3054@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
	 <1336159496.6509.51.camel@twins> <4FA434E9.6000305@linux.vnet.ibm.com>
	 <1336162456.6509.63.camel@twins> <1336163281.6509.69.camel@twins>
	 <20120504204908.GC18177@linux.vnet.ibm.com>
	 <1336165294.6509.76.camel@twins> <20120504212758.GC3054@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 14:27 -0700, Nishanth Aravamudan wrote:
> >  - if you retain it for cpuset but not others that's confusing (too);
> 
> That's a good point.
> 
> Related, possibly counter-example, and perhaps I'm wrong about it.  When
> we hot-unplug a CPU, and a task's scheduler affinity (via
> sched_setaffinity) refers to that CPU only, do we kill that task? Can
> you sched_setaffinity a task to a CPU that is offline (alone or in a
> group of possible CPUs)? Or is it allowed to run anywhere? Do we destroy
> its affinity policy when that situation is run across?

See a few emails back, we destroy the affinity. Current cpuset behaviour
can be said to match that.

>  Or do we restore the task to the CPU again when we re-plug it?

Nope that information is lost forever from the kernels pov.

Keeping this information around for the off-chance of needing it is
rather expensive (512 bytes per task for your regular distro kernel that
has NR_CPUS=4096).

