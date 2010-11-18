Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab0KRTwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:52:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:45918 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab0KRTwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:52:50 -0500
Message-ID: <4CE583D0.8050407@windriver.com>
Date: Thu, 18 Nov 2010 13:51:44 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
References: <20101112154231.GN4823@redhat.com> <4CDD6389.2080206@windriver.com> <20101112161144.GP4823@redhat.com> <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com>
In-Reply-To: <20101118193247.GF18100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 19:51:47.0147 (UTC) FILETIME=[089C79B0:01CB875A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 01:32 PM, Don Zickus wrote:
> On Thu, Nov 18, 2010 at 02:17:12PM +0100, Peter Zijlstra wrote:
>   
>> On Thu, 2010-11-18 at 06:47 -0600, Jason Wessel wrote:
>>     
>>> More specifically
>>> when another subsystem injects an NMI event the perf NMI code returns
>>> NOTIFY_STOP. 
>>>       
>> Not unconditionally, right? We only do so when the previous NMI was from
>> the PMU and nobody claimed this one (NOTIFY_STOP from DIE_NMIUNKNOWN).
>>
>> Or are you hitting the other one, where !handled but pmu_nmi.handled >
>> 1 ?
>>     
>
> I think the problem with the virt stuff is that it emulates 0 to the
> rdmsrl calls.  All platforms except perf_events_intel.c rely on checking
> the high bit of the counter register to not be zero, otherwise the code
> thinks it crossed zero and triggered an PMI.
>
> The intel code is a litte smarter and relies on the interrupt logic and
> thus doesn't have this problem (to clarify only core2 and later use this,
> p4 and p6 use the old methods).
>
> So the problem is when the nmi watchdog is enabled, the perf event is
> 'active' and thus tries to read the counter value.  Because it is always
> zero, perf just assumes the counter overflowed and the NMI is his.
>
> Not sure how to fix it yet, other than include the logic that detects we
> are on a guest and disable perf??
>
>   

I highly doubt we want to disable perf.   I would rather use the source
and fix the nmi emulation in KVM/Qemu after we hear back the results
from Cyril because it sounds as if the problem is nearly bottomed out.

I have no problem what so ever updating kvm / qemu if that is final
place we need some fixes.

Thanks,
Jason.
