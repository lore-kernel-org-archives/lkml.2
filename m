Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2EUT61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:58:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:64623 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab2EUT6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:58:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155318449"
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Gordeev <agordeev@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Yinghai Lu <yinghai@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Date: Mon, 21 May 2012 12:56:48 -0700
In-Reply-To: <20120521191546.GA28819@gmail.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
	 <20120521082240.GA31407@gmail.com>
	 <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
	 <20120521124025.GC17065@gmail.com>
	 <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
	 <20120521145904.GA7068@gmail.com>
	 <CA+55aFxJxfx+OfDiATCCPojVAPew_Hy+2=jx9g4=2_WRvixBFw@mail.gmail.com>
	 <20120521191546.GA28819@gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337630208.1997.141.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 21:15 +0200, Ingo Molnar wrote:
> The one negative effect I mentioned, affine wakeups done by the 
> scheduler, could still bite us - this has to be measured and 
> affine wakeups have to be made less prominent if IRQ handlers 
> start jumping around. We definitely don't want tasks to follow 
> round-robin IRQs around.

Actually this (ping-ponging around idle cpu's in a socket) happens
already today, as the affine wakeups use select_idle_sibling() to wake
up the task on an idle sibling (HT or core sibling) if the cpu on which
the task is woken-up is busy with something else.

But I agree, somehow all these need to work together. For example to
save power, what we want is the idle core to stay in idle with least
number of interruptions, with interrupts routed to busy cores, scheduler
not aggressively waking the tasks up on idle cores etc.

One quick thought is to use the cpufreq governor decisions and if all
the cpu's in the package are in lower p-states, then we can default for
power-saving decisions, otherwise if any cpu is at P0, switch for
performance policy(in terms of irq routing, scheduler wake-up decisions
etc) dynamically etc.

thanks,
suresh



