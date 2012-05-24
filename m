Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2EXL7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 07:59:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50661 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab2EXL7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 07:59:23 -0400
Subject: Re: [PATCH v5 4/5] cpusets: Update tasks' cpus_allowed mask upon
 updates to root cpuset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        rientjes@google.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
In-Reply-To: <4FBE02F3.3030809@linux.vnet.ibm.com>
References: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
	 <20120517170055.3011.18690.stgit@srivatsabhat.in.ibm.com>
	 <1337850827.9783.77.camel@laptop>  <4FBE02F3.3030809@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 13:58:56 +0200
Message-ID: <1337860736.9783.123.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 15:14 +0530, Srivatsa S. Bhat wrote:

> Sorry, my bad, I hadn't considered that. Thanks for pointing it out!
> 
> So, I am wondering how we ought to deal with CPU hotplug for tasks attached
> to the root cpuset..

By not doing anything at all. If a task is in the root set it is
supposed to behave as it cpusets don't exist.

> Considering tasks attached to the root cpuset, if a cpu present in a task's
> cpus_allowed mask goes offline, it should be removed from that mask right?

Nope, that shouldn't happen. We only reset the mask if all cpus in the
affinity mask go away. This is where task affinity and cpusets differ.

> And if that cpu comes back online, it should not be put back to the task's
> cpus_allowed mask (just like we don't put back cpus in non-root cpusets).

Online shouldn't ever change anything.

> Is the above understanding correct?

Nope.

> In the current kernel, during cpu hotplug, we don't touch cpus_allowed mask
> of the tasks attached to the root cpuset at all.. Whereas we update the
> cpus_allowed mask of tasks belonging to non-root cpusets, during cpu offline.
> 
> So, is this differentiation intended?

Yes, although arguably the cpuset case is 'weird' in that it came later
and didn't mirror the cpu affinity semantics.

Tasks aren't attached to the root cpuset, they live there because
there's no other place to be when you don't use cpusets. This very much
means that tasks in the root set should behave as if cpusets didn't
exist.



