Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2EILCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:02:34 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57291 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533Ab2EILCc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:02:32 -0400
MIME-Version: 1.0
In-Reply-To: <1336537289.7365.62.camel@marge.simpson.net>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
	<1335830115-14335-8-git-send-email-fweisbec@gmail.com>
	<alpine.DEB.2.00.1205071053070.1060@router.home>
	<CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
	<1336488626.16236.41.camel@twins>
	<alpine.DEB.2.00.1205081016370.27713@router.home>
	<1336490832.8226.5.camel@twins>
	<alpine.DEB.2.00.1205081035550.27713@router.home>
	<1336492081.8226.13.camel@twins>
	<alpine.DEB.2.00.1205081054310.27713@router.home>
	<1336493768.8226.29.camel@twins>
	<1336506601.7400.21.camel@marge.simpson.net>
	<alpine.DEB.2.00.1205081541010.1391@router.home>
	<1336537289.7365.62.camel@marge.simpson.net>
Date: Wed, 9 May 2012 13:02:30 +0200
Message-ID: <CAFTL4hzrTXsVucJDHrirDTxM7NwxD5DKuGjRW3fkiWmHyHUOpg@mail.gmail.com>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/9 Mike Galbraith <efault@gmx.de>:
> On Tue, 2012-05-08 at 15:45 -0500, Christoph Lameter wrote:
>> On Tue, 8 May 2012, Mike Galbraith wrote:
>>
>> > On Tue, 2012-05-08 at 18:16 +0200, Peter Zijlstra wrote:
>> > > On Tue, 2012-05-08 at 10:57 -0500, Christoph Lameter wrote:
>> >
>> > > isolcpus is a very limited hack that adds more pain that its worth. Its
>> > > yet another mask to check and its functionality is completely available
>> > > through cpusets.
>> >
>> > Agreed.
>>
>> How would that work? By creating cpusets that only have a single cpu in
>> them?
>
> No, just turn load balancing off for exclusive set, domains go poof.

I don't think it's

>> > > You cannot cree multi-cpu partitions using isolcpus, you cannot
>> > > dynamically reconfigure it.
>> >
>> > Big plus for cpusets.
>>
>> Why would you want to do anything like it? cpusets are confusing. You can
>> have a cpu be part of multiple cpusets. Which nohz setting applies for a
>> particular cpu then? If any of the cpusets have nohz set then it applies
>> to the cpu? And thus someone in a cpuset that does not has nohz set will
>> find that a cpu will have nohz functionality?
>
> nohz has to be at least an exclusive set property.
>
>> Its not a good match for this. You would want a per cpu attribute for
>> nohz.
>
> Or per cpuset, which can be the same thing as per cpu if you want.
>
>> > > And on the scheduler side cpusets doesn't add runtime overhead to normal
>> > > things, only sched_setaffinity() and a few other rare operations get
>> > > slightly more expensive. And it allows to reduce runtime overhead by
>> > > making the load-balancer domains smaller.
>> >
>> > Very big deal if you have a load that doesn't do all the performance 'i'
>> > dotting and 't' crossing it maybe could have, but ends up on a big box.
>>
>> isolcpus are not part of load balancer domains.
>
> Yup, so if you have an application with an RT component, somewhat
> sensitive, needs isolation from rest of a big box, but app also has
> SCHED_OTHER components.  isolcpus is a pain, everything has to be static
> and nailed to the floor.  Load just works when plugged into a cpuset.
>
> -Mike
>
