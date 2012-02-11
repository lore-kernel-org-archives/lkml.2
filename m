Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab2BKCHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 21:07:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35267 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2BKCHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 21:07:46 -0500
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paul@paulmenage.org, tj@kernel.org, frank.rowand@am.sony.com,
        pjt@google.com, tglx@linutronix.de, lizf@cn.fujitsu.com,
        prashanth@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <201202102339.02702.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org>
	 <201202102339.02702.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Feb 2012 03:07:22 +0100
Message-ID: <1328926042.2476.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 23:39 +0100, Rafael J. Wysocki wrote:
> 
> > I don't see why not.  Presumably no CPUs will be added or removed while 
> > the system is asleep.
> 
> ACPI explicitly forbids that level of hardware reconfiguration in a sleep
> state (even in S4), AFAICS.  Still, people may try to do that ... 

I'm ok with breaking that :-) If its really really important to someone
we (him most likely) could fix it by detecting the topology changed over
the suspend and do a fixup. Assuming it actually gets that far.

Srivatsa, wanna give this (the proposal to not modify cpusets on
CPU_TASKS_FROZEN) a try?


