Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab2BKE1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 23:27:12 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:33597 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2BKE1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 23:27:09 -0500
Message-ID: <4F35EE11.5010202@linux.vnet.ibm.com>
Date: Sat, 11 Feb 2012 09:56:57 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        paul@paulmenage.org, tj@kernel.org, frank.rowand@am.sony.com,
        pjt@google.com, tglx@linutronix.de, lizf@cn.fujitsu.com,
        prashanth@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling related
 to cpusets
References: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org> <201202102339.02702.rjw@sisk.pl> <1328926042.2476.3.camel@laptop>
In-Reply-To: <1328926042.2476.3.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021104-2000-0000-0000-00000660749C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2012 07:37 AM, Peter Zijlstra wrote:

> On Fri, 2012-02-10 at 23:39 +0100, Rafael J. Wysocki wrote:
>>
>>> I don't see why not.  Presumably no CPUs will be added or removed while 
>>> the system is asleep.
>>
>> ACPI explicitly forbids that level of hardware reconfiguration in a sleep
>> state (even in S4), AFAICS.  Still, people may try to do that ... 
> 
> I'm ok with breaking that :-) If its really really important to someone
> we (him most likely) could fix it by detecting the topology changed over
> the suspend and do a fixup. Assuming it actually gets that far.
> 
> Srivatsa, wanna give this (the proposal to not modify cpusets on
> CPU_TASKS_FROZEN) a try?
> 


Sure! After you pointed out that CPU Hotplug is destructive in general and
hence it is not a good idea to put back online CPUs to cpusets, the next
thing I thought of trying was a special case handling for suspend/resume
alone, IOW, not calling the cpuset update upon CPU_TASKS_FROZEN.

So, yes, I'll write up a patch for that and post it soon :-)

Regards,
Srivatsa S. Bhat

