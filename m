Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0KPQF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:05:56 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:43123 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0KPQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:05:55 -0500
Date: Tue, 16 Nov 2010 17:05:49 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
        "jeremy.fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time
 accounting
Message-ID: <20101116170549.05d9e5c6@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1289922329.2109.627.camel@laptop>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	<20101111170815.024542355@linux.vnet.ibm.com>
	<1289677083.2109.167.camel@laptop>
	<20101115155057.15f3be35@mschwide.boeblingen.de.ibm.com>
	<1289833883.2109.494.camel@laptop>
	<20101115184206.4463fd05@mschwide.boeblingen.de.ibm.com>
	<1289843441.2109.520.camel@laptop>
	<20101115185923.1c353d07@mschwide.boeblingen.de.ibm.com>
	<1289844524.2109.524.camel@laptop>
	<20101116095101.5d86d1e5@mschwide.boeblingen.de.ibm.com>
	<1289909768.2109.592.camel@laptop>
	<20101116163325.755a709f@mschwide.boeblingen.de.ibm.com>
	<1289922329.2109.627.camel@laptop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 16:45:29 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > Except that the per-task steal time gives you lot less detail, being
> > > able to profile on vcpu exit/enter gives you a much more powerfull
> > > performance tool. Aside from being able to measure the steal-time it
> > > allows you to instantly find hypercalls (both explicit as well as
> > > implicit), so you can also measure the hypercall induced steal-time as
> > > well.
> > 
> > Yes and no. The tracepoint idea looks interesting in itself. But that does
> > not completely replace the per-task steal time. The hypervisor can take
> > away the cpu anytime, it is still interesting to know which task was hit
> > hardest by that. You could view the cpu time lost by a hypercall as
> > "synchronous" steal time for the task, the remaining delta to the total
> > per-task steal time as "asynchronous" steal time. 
> 
> Right, so there is no way the guest knows about the vcpu getting
> scheduled, it can only derive the fact from hardware clocks after the
> fact?

Correct.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

