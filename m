Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab2BJPwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:52:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:60081 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab2BJPwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:52:17 -0500
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paul@paulmenage.org,
        rjw@sisk.pl, tj@kernel.org, frank.rowand@am.sony.com, pjt@google.com,
        tglx@linutronix.de, lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20120209151158.GA22489@elte.hu>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
	 <1328671335.2482.72.camel@laptop> <4F32174E.2050207@linux.vnet.ibm.com>
	 <20120209075701.GE18387@elte.hu> <4F3386E9.7090606@linux.vnet.ibm.com>
	 <20120209151158.GA22489@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 16:52:07 +0100
Message-ID: <1328889127.25989.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 16:11 +0100, Ingo Molnar wrote:

> > My understanding of the code is that when a CPU is taken 
> > offline, it is removed from all the cpusets and then the 
> > scan_for_empty_cpusets() function is run to move tasks from 
> > empty cpusets to their parent cpusets.
> 
> Why is that done that way? offlining a CPU should be an 
> invariant as far as cpusets are concerned.

Can't, tasks need to run someplace. There's two choices, add a still
online cpu to the now empty cpuset or move the tasks to a parent that
still has online cpus.

Both are destructive.



