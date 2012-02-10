Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257Ab2BJVvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:51:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37569 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753947Ab2BJVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:51:18 -0500
Date: Fri, 10 Feb 2012 16:51:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        <paul@paulmenage.org>, <rjw@sisk.pl>, <tj@kernel.org>,
        <frank.rowand@am.sony.com>, <pjt@google.com>, <tglx@linutronix.de>,
        <lizf@cn.fujitsu.com>, <prashanth@linux.vnet.ibm.com>,
        <vatsa@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling related
 to cpusets
In-Reply-To: <1328895244.25989.25.camel@laptop>
Message-ID: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012, Peter Zijlstra wrote:

> Now the whole problem here seems to be that suspend uses cpu-hotplug to
> reduce the machine to UP -- I've no clue why it does that but I can
> imagine its because the BIOS calls only work on CPU0 and/or the resume
> only wakes CPU0 so you have to bootstrap the SMP thing again..
> 
> Some suspend person wanna clarify? Rafael?

If I understand correctly, ACPI requires that only CPU0 be running when
the system is suspended (i.e., your guess is right).  Of course, this
doesn't apply to non-ACPI systems, but it's easiest to do the same
thing everywhere.

> Anyway, the whole suspend case is magic anyway since all tasks will have
> been frozen, so we could simply leave all of cpuset alone and ignore the
> hotplug notifier on CPU_TASKS_FROZEN callbacks, hmm?

I don't see why not.  Presumably no CPUs will be added or removed while 
the system is asleep.

> Do we unfreeze after we bring up the machine again?

Yes.

Alan Stern

