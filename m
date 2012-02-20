Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2BTPKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:10:14 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:56958 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2BTPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:10:12 -0500
Date: Mon, 20 Feb 2012 20:39:48 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: sched: Performance of Trade workload running inside VM
Message-ID: <20120220150943.GD2350@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
 <1329307161.2293.66.camel@twins>
 <20120215171032.GB9918@linux.vnet.ibm.com>
 <1329326651.2293.151.camel@twins>
 <20120215173817.GD9918@linux.vnet.ibm.com>
 <1329327902.2293.168.camel@twins>
 <20120218074127.GA9077@linux.vnet.ibm.com>
 <1329749790.2293.354.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329749790.2293.354.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022004-5490-0000-0000-000000C5FFB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-02-20 15:56:30]:

> > Another variant of the patch could be to have select_idle_sibling() look
> > for any idle cpu that is in same cache domain (rather than looking for a
> > whole group of cpus to be idle)?
> 
> Right, so I looked over select_idle_sibling() again and it made my head
> hurt :/

I can vouch for it :-)

> I can't immediately tell if its actually doing the right thing
> or not (it _should_ try and avoid using SMT siblings if possible).

Yes makes sense.

> It would be very nice not to have both select_idle_sibling() and
> SD_BALANCE_WAKE iterate the domain tree. So merging them if at all
> possible would be goodness I think.

Right. Let me see how that can be worked out in my next version.

> We'd have WAKE_AFFINE to decide which cache domain etc to stuff the task
> on and then use select_idle_sibling() to find the most appropriate cpu
> within that cache domain.
> 
> There was talk of modifying select_idle_sibling() to also consider the
> C-state the cpu was in, preferring shallower over deeper C-states where
> there's choice,

Ok ..interesting. /me goes and educates himself how this info can be dug
out.

> this is very similar to what you propose, taking the
> least loaded cpu when there isn't a proper idle one around.

Thanks for the feedback ..

- vatsa

