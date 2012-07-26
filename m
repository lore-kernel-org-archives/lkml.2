Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2GZLNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:13:23 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39410 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab2GZLNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:13:22 -0400
Message-ID: <50112647.1020206@linux.vnet.ibm.com>
Date: Thu, 26 Jul 2012 16:43:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alan Stern <stern@rowland.harvard.edu>, mingo@kernel.org,
        peterz@infradead.org, rusty@rustcorp.com.au,
        paulmck@linux.vnet.ibm.com, namhyung@kernel.org, tj@kernel.org,
        rjw@sisk.pl, nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers
 during CPU hotplug
References: <Pine.LNX.4.44L0.1207251054420.2008-100000@iolanthe.rowland.org> <50101733.4030205@linux.vnet.ibm.com> <alpine.LFD.2.02.1207251758340.32033@ionos> <50103955.9020301@linux.vnet.ibm.com> <alpine.LFD.2.02.1207261248130.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207261248130.32033@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072611-3864-0000-0000-000003EC2823
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 04:25 PM, Thomas Gleixner wrote:
> On Wed, 25 Jul 2012, Srivatsa S. Bhat wrote:
>> On 07/25/2012 10:00 PM, Thomas Gleixner wrote:
>>> struct hotplug_event hotplug_events_bp[CPU_HOTPLUG_MAX_EVENTS];
>>> struct hotplug_event hotplug_events_ap[CPU_HOTPLUG_MAX_EVENTS];
>>>    
>>> The _bp one is the list of events which are executed on the active cpu
>>> and the _ap ones are those executed on the hotplugged cpu.
>>>
>>> The core code advances the events in sync steps, so both BP and AP can
>>> issue a stop on the process and cause a rollback.
>>
>> What exactly does "sync steps" mean in this context? Also, for the CPU
> 
> Sync step means, that both sides need to synchronize - not at every
> step, but at well defined synchronization points. You can't advance
> the AP to online state unless the BP has done the preparatory stuff
> already.
> 
>> offline event, the event could start off with both the BP and the AP being
>> the same CPU.. Does this design take care of that case?
> 
> Once the AP leaves the state where tasks can be freely scheduled on
> it, the take down thread migrates automagically. And that's one of the
> first things I'm trying to do so the first synchronization point is
> after that.
> 

Oh.. Ok.. Thanks for the explanation!

Regards,
Srivatsa S. Bhat

