Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1CYVoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:44:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1CYVoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:44:38 -0400
Subject: Re: [RFC][PATCH 00/14] Rewrite sched_domain/sched_group creation
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
In-Reply-To: <20110314150613.749843433@chello.nl>
References: <20110314150613.749843433@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 22:46:41 +0100
Message-ID: <1301089601.2250.314.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 16:06 +0100, Peter Zijlstra wrote:
> So I got annoyed with the whole sched_domain/sched_group creation mess again
> and decided to actuall do something about it. See here ;-)
> 
> Its not completely done yet, but much of the ground-work is there.
> 
> The final goal is to be able to have a simple way to dynamically specify the
> architecture topoplogy and have the generic code in charge of building the data
> structures. The architecture would need to provide a function that maps a cpu
> to a cpumask and a function that initializes the sched_domain (flags etc.),
> this would replace the now still hard-coded __build_*_sched_domain() calls in
> __build_sched_domains().

Got to here last friday a week ago, and started on:

> With that we can also kill the current NODE and ALLNODES mess and generate
> appropriate masks from say the ACPI SLIT table by grouping CPUs on their node
> distance.

which I just finished.

> This would allow us to kill the horrid mess in x86's cpu_coregroup_mask() and
> properly support the AMD magnycours stuff.

Still todo.

> Anyway, not quite there yet.. patches build and boot on a 2*6*2 wsm box.

Still boots, although a 2 node system isn't very interesting.

I pushed out an updated version to:

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git sched_domain

we're now at:

 include/linux/sched.h    |   26 +-
 include/linux/topology.h |   25 -
 kernel/cpuset.c          |    2 +-
 kernel/sched.c           | 1094 ++++++++++++++++------------------------------
 kernel/sched_fair.c      |   32 +-
 5 files changed, 407 insertions(+), 772 deletions(-)



