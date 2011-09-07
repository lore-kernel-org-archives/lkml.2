Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1IGMUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 08:20:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:49405 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab1IGMUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 08:20:31 -0400
Date: Wed, 7 Sep 2011 12:57:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Frank Rowand <frank.rowand@am.sony.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@tglx.de>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
In-Reply-To: <20110907104747.GA29282@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1109071254010.2723@ionos>
References: <1313232790.25267.7.camel@twins> <4E559039.8060209@am.sony.com> <20110826235507.GJ2342@linux.vnet.ibm.com> <4E66DCAB.8090801@am.sony.com> <alpine.LFD.2.02.1109071115410.2723@ionos> <20110907104633.GR6619@n2100.arm.linux.org.uk>
 <20110907104747.GA29282@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011, Russell King - ARM Linux wrote:

> On Wed, Sep 07, 2011 at 11:46:33AM +0100, Russell King - ARM Linux wrote:
> > I think we had this reported before and I got to the bottom of it - the
> > platform was doing something it shouldn't.  I don't remember the details,
> > maybe when all the emails come through I can see the original bug report
> > I'll remember.
> 
> Or maybe I won't because it was never posted to an ARM mailing list.
> So I've no idea what the real bug report is about or what has already
> been discussed.

The problem is that if you enable interrupts on the CPU _BEFORE_ it is
set online AND active, then you can end up waking up kernel threads
which are bound to that CPU and the scheduler will happily schedule
them on an online CPU. That makes them lose the cpu affinity to the
CPU as well and hell breaks lose.

Frank has observed this with softirq threads, but the same thing is
true for any other CPU bound thread like the worker stuff.

So moving the online, active thing BEFORE enabling interrupt is the
only sensible solution.

Thanks,

	tglx



