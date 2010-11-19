Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab0KSXb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:31:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:53071 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab0KSXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:31:26 -0500
Message-ID: <4CE708AA.7030405@windriver.com>
Date: Fri, 19 Nov 2010 17:30:50 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
References: <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com> <4CE583D0.8050407@windriver.com> <20101118200807.GC8131@redhat.com> <1290112234.2109.1534.camel@laptop> <20101119165952.GJ18100@redhat.com> <1290191158.2109.1614.camel@laptop>  <20101119225902.GQ18100@redhat.com> <1290208179.2114.13.camel@laptop>
In-Reply-To: <1290208179.2114.13.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2010 23:30:53.0470 (UTC) FILETIME=[CED7EBE0:01CB8841]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2010 05:09 PM, Peter Zijlstra wrote:
> On Fri, 2010-11-19 at 17:59 -0500, Don Zickus wrote:
>> 
>> @@ -1371,6 +1385,12 @@ void __init init_hw_perf_events(void)
>> 
>>         pmu_check_apic();
>> 
>> +       /* sanity check that the hardware exists or is emulated */
>> +       if (!check_hw_exists()) {
>> +               pr_cont("no PMU driver, software events only.\n");
>> +               return;
>> +       }
>
> Maybe report something like this:
>   "Broken PMU hardware detected, software events only."
>
> Because this is really not something that's supposed to happen.

The kgdb test suite is passing with Don's perf detect logic, so we are
back to good.  I am in agreement with Peter about the message
indicating that it is broken hardware.  We don't in any way shape or
form want leave the illusion this works in the VM.

# dmesg |grep Per
<6>Performance Events: no PMU driver, software events only.


Tested on qemu and kvm, several revisions worth, because it is all
automated.

Tested-by: Jason Wessel <jason.wessel@windriver.com>

Thanks,
Jason.
