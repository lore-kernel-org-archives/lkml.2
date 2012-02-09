Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2BIQo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:44:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37456 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2BIQo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:44:57 -0500
Date: Thu, 9 Feb 2012 17:43:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paul@paulmenage.org,
        mingo@elte.hu, rjw@sisk.pl, tj@kernel.org, frank.rowand@am.sony.com,
        pjt@google.com, tglx@linutronix.de, lizf@cn.fujitsu.com,
        prashanth@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
Message-ID: <20120209164357.GA5218@dyad.programming.kicks-ass.net>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
 <1328671335.2482.72.camel@laptop>
 <4F32174E.2050207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F32174E.2050207@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 12:03:50PM +0530, Srivatsa S. Bhat wrote:
> On 02/08/2012 08:52 AM, Peter Zijlstra wrote:
> 
> > On Wed, 2012-02-08 at 00:25 +0530, Srivatsa S. Bhat wrote:
> >> There is a very long standing issue related to how cpusets handle CPU
> >> hotplug events. The problem is that when a CPU goes offline, it is removed
> >> from all cpusets. However, when that CPU comes back online, it is added
> >> *only* to the root cpuset. Which means, any task attached to a cpuset lower
> >> in the hierarchy will have one CPU less in its cpuset, though it had this
> >> CPU in its cpuset before the CPU went offline.
> > 
> > Yeah so? That's known behaviour..
> 
> 
> This might be a known behaviour, but this is surely not the behaviour we
> want right? I understand that if you take a CPU offline, we have no other
> choice but to remove it from all cpusets. But if the same CPU comes back
> online and the userspace did not request any change to cpusets in between
> those events (offline-online), then is it not wrong to silently keep that
> CPU out of the cpuset even when it comes online?

no, it is what we want because unplug is destructive, it cannot be undone in generic. consider the case where you unplug allcpus of a set. 
