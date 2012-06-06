Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2FFMRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:17:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:34851 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2FFMRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:17:38 -0400
Message-ID: <1338985041.2749.107.camel@twins>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 06 Jun 2012 14:17:21 +0200
In-Reply-To: <20120605220059.GV2388@linux.vnet.ibm.com>
References: <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	 <1338912565.2749.9.camel@twins>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	 <1338913190.2749.10.camel@twins>
	 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
	 <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos>
	 <1338925756.2749.36.camel@twins> <20120605212947.GA8686@linux.vnet.ibm.com>
	 <1338932241.2749.62.camel@twins> <20120605220059.GV2388@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 15:00 -0700, Paul E. McKenney wrote:
> On Tue, Jun 05, 2012 at 11:37:21PM +0200, Peter Zijlstra wrote:
> > On Tue, 2012-06-05 at 14:29 -0700, Paul E. McKenney wrote:
> > > OK, I'll bite...  Why not just use CPU hotplug to expel the timers?
> > 
> > Currently? Can you say: 'kstopmachine'?
> 
> So if CPU hotplug (or whatever you want to call it) stops using
> kstopmachine, you are OK with it?

It would be much better, still not ideal though.

> > But its also a question of interface and naming. Do you want to have to
> > iterate all cpus in your isolated set, do you want to bring them down
> > far enough to physically unplug. Ideally no to both.
> 
> For many use cases, it is indeed not necessary to get to a point where
> the CPUs could be physically removed from the system.  But CPU-failure
> use cases would need the CPU to be fully deactivated.  And many of the
> hardware guys tell me that the CPU-failure case will be getting more
> common, though I sure hope that they are wrong.

Uhm, yeah, that doesn't sound right.

