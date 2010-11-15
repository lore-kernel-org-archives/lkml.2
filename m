Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab0KOPLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:11:44 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56114 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab0KOPLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:11:43 -0500
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time
 accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        "jeremy.fitzhardinge" <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <20101115155057.15f3be35@mschwide.boeblingen.de.ibm.com>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170815.024542355@linux.vnet.ibm.com>
	 <1289677083.2109.167.camel@laptop>
	 <20101115155057.15f3be35@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 16:11:23 +0100
Message-ID: <1289833883.2109.494.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 15:50 +0100, Martin Schwidefsky wrote:
> On Sat, 13 Nov 2010 20:38:02 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2010-11-11 at 18:03 +0100, Michael Holzheu wrote:
> > > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > > 
> > > Currently steal time is only accounted for the whole system. With this
> > > patch we add steal time to the per task CPU time accounting.
> > > The triplet "user time", "system time" and "steal time" represents
> > > all consumed CPU time on hypervisor based systems. 
> > 
> > Does that really make sense? Its not like the hypervisor really knows
> > anything about tasks and won't steal from one? Its really a vcpu
> > feature.
> > 
> > What added benefit will all this extra accounting give?
> 
> Currently the linux kernel keeps track of used cpu cycles per task,
> steal time is reported only per cpu. With the patch steal cycles are
> reported per task just like used cpu cycles, giving the complete picture
> on a per task basis. Without the patch you don't know if the task has
> been waiting or got its cycles stolen. A matter of granularity. 

That doesn't answer my question at all. Why do you want to know? Also,
once we change the scheduler to not account steal time to tasks like it
currently does (as Jeremy has been proposing to do several times now)
this should become totally redundant as it will always be 0, no?

Thing is, all I'm seeing is overhead here, the vast majority of systems
simply don't have any steal time at all. So again, what does this buy us
except a gazillion wasted bytes and cycles?
