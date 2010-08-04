Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab0HDWbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:31:55 -0400
Received: from mail.lang.hm ([64.81.33.126]:50249 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739Ab0HDWbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:31:50 -0400
Date: Wed, 4 Aug 2010 15:31:17 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100804205654.GA4986@srcf.ucam.org>
Message-ID: <alpine.DEB.2.00.1008041529530.6545@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org> <201008042251.08266.rjw@sisk.pl> <20100804205654.GA4986@srcf.ucam.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Matthew Garrett wrote:

> On Wed, Aug 04, 2010 at 10:51:07PM +0200, Rafael J. Wysocki wrote:
>> On Wednesday, August 04, 2010, Matthew Garrett wrote:
>>> No! And that's precisely the issue. Android's existing behaviour could
>>> be entirely implemented in the form of binary that manually triggers
>>> suspend when (a) the screen is off and (b) no userspace applications
>>> have indicated that the system shouldn't sleep, except for the wakeup
>>> event race. Imagine the following:
>>>
>>> 1) The policy timeout is about to expire. No applications are holding
>>> wakelocks. The system will suspend providing nothing takes a wakelock.
>>> 2) A network packet arrives indicating an incoming SIP call
>>> 3) The VOIP application takes a wakelock and prevents the phone from
>>> suspending while the call is in progress
>>>
>>> What stops the system going to sleep between (2) and (3)? cgroups don't,
>>> because the voip app is an otherwise untrusted application that you've
>>> just told the scheduler to ignore.
>>
>> I _think_ you can use the just-merged /sys/power/wakeup_count mechanism to
>> avoid the race (if pm_wakeup_event() is called at 2)).
>
> Yes, I think that solves the problem. The only question then is whether
> it's preferable to use cgroups or suspend fully, which is pretty much up
> to the implementation. In other words, is there a reason we're still
> having this conversation? :) It'd be good to have some feedback from
> Google as to whether this satisfies their functional requirements.

the proposal that I nade was not to use cgroups to freeze some processes 
and not others, but to use cgroups to decide to ignore some processes when 
deciding if the system is idle, stop everything or nothing. cgroups are 
just a way of easily grouping processes (and their children) into 
different groups.

David Lang
