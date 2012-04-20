Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab2DTN4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:56:37 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:57595 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2DTN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:56:34 -0400
Message-ID: <4F916AF3.7020301@linux.vnet.ibm.com>
Date: Fri, 20 Apr 2012 19:26:03 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
References: <20120420122120.097464672@linutronix.de>
In-Reply-To: <20120420122120.097464672@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12042003-1396-0000-0000-00000103F95F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 04/20/2012 06:35 PM, Thomas Gleixner wrote:

> Dear all,
> 
> I'm working on refactoring the SMP boot and CPU hotplug implementation.
>


Awesome!

[Unfortunately I got stuck with some other issues recently and couldn't
dedicate enough time (to come up with working code) so far :-( ]

 
> The current code has evolved over time into a conglomerate of
> warts. My main goals are to:
> 
>  - reduce the architecture code by moving repeating constructs to the
>    core
> 
>  - redesigning the handling of per cpu threads. There is no point to
>    tear down the threads just to create them again.
> 
>  - restructuring the notifier facility into a proper tree with
>    dependencies to avoid the gazillion of callbacks and moving
>    setup/teardown code into the context of the upcoming/dying cpu
> 
> The motivation behind this work is the cpu hotplug nightmare which we
> are facing in the RT kernel and the requests from several groups
> (e.g. ARM) to make hotplug more lightweight and faster.
> 
> This first part moves the idle thread management for non-boot cpus
> into the core. fork_idle() is called in a workqueue as it is
> implemented in a few architectures already. This is necessary when not
> all cpus are brought up by the early boot code as otherwise we would
> take a ref on the user task VM of the thread which brings the cpu up
> via the sysfs interface.
> 


Do you have a git tree where you have made these patches available?
That would be pretty useful, so that we can build on whatever you have
already done.. Myself and Nikunj had some initial design/ideas on reducing
the duplication in architecture code, related to managing the setting
of the cpu in the online mask, sending out CPU_STARTING notifiers etc
from generic code..

Regards,
Srivatsa S. Bhat 

